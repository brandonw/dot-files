-- Claude Code agents, one per tab.
--
-- Each agent is a tab running `claude` in a terminal, with the tab-local cwd set
-- to the directory the agent works in. :AgentsSave writes the running agents to
-- a manifest, and :AgentsRestore resumes each one with
-- `claude --resume <session id>`.
--
-- Session ids and busy/idle status come from $CLAUDE_CONFIG_DIR/sessions/<pid>.json,
-- which Claude Code writes for every running process. It is undocumented, but
-- it is what `claude agents --json` reads, and it is cheap enough to poll.
local M = {}

M.cmd = "claude --dangerously-skip-permissions"
M.manifest = vim.fn.stdpath("state") .. "/claude-agents.json"
M.sessions_dir = vim.fs.normalize(vim.env.CLAUDE_CONFIG_DIR or "~/.claude") .. "/sessions"

---@type table<integer, {session_id?: string, name?: string, named?: boolean, cwd?: string, status?: string, unseen?: boolean}>
local state = {}
local focused = true
local last_labels

local function read_json(path)
  local fd = io.open(path, "r")
  if not fd then
    return nil
  end
  local ok, data = pcall(vim.json.decode, fd:read("*a"))
  fd:close()
  return ok and data or nil
end

local function write_file(path, data)
  local tmp = path .. ".tmp"
  local fd = assert(io.open(tmp, "w"))
  fd:write(data)
  fd:close()
  assert(os.rename(tmp, path))
end

-- Agents opened by M.open are marked, as their terminals are named after the
-- shell that starts them. Others are named like term://~/code/foo//1234:claude --flags
function M.is_agent(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "terminal" then
    return false
  end
  if vim.b[buf].claude_agent then
    return true
  end
  local cmd = vim.api.nvim_buf_get_name(buf):match("^term://.-//%d+:(%S+)")
  return cmd ~= nil and vim.fs.basename(cmd) == "claude"
end

local function term_cwd(buf)
  return vim.fs.normalize(vim.api.nvim_buf_get_name(buf):match("^term://(.-)//%d+:"))
end

local function running(buf)
  return vim.fn.jobwait({ vim.bo[buf].channel }, 0)[1] == -1
end

-- Claude's own state for the process in buf, once it has started up.
local function session(buf)
  local pid = vim.b[buf].terminal_job_pid
  local s = pid and read_json(("%s/%d.json"):format(M.sessions_dir, pid))
  return s and s.pid == pid and s or nil
end

local function visible(buf)
  if not focused or #vim.api.nvim_list_uis() == 0 then
    return false
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end
  return false
end

-- Agent buffers in tab order, then any hidden ones.
function M.list()
  local seen, bufs = {}, {}
  local function add(buf)
    if not seen[buf] and M.is_agent(buf) then
      seen[buf] = true
      table.insert(bufs, buf)
    end
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      add(vim.api.nvim_win_get_buf(win))
    end
  end
  vim.tbl_map(add, vim.api.nvim_list_bufs())
  return bufs
end

-- The session name: whatever /rename set, otherwise "<dir>-<2 hex chars>".
-- Until claude starts up and reports it, the directory name.
function M.title(buf)
  local st = state[buf] or {}
  return st.name or vim.fs.basename(st.cwd or term_cwd(buf))
end

local icons = { busy = "● ", starting = "… ", exited = "✗ " }

function M.label(buf)
  local st = state[buf] or {}
  local icon = st.status == "exited" and icons.exited or st.unseen and "✔ " or icons[st.status] or ""
  return icon .. M.title(buf)
end

-- bufferline name_formatter: label tabs holding an agent after the agent.
function M.tab_name(tab)
  for _, buf in ipairs(tab.buffers or { tab.bufnr }) do
    if M.is_agent(buf) then
      return M.label(buf)
    end
  end
end

local function refresh(buf)
  local st = state[buf] or {}
  state[buf] = st
  local s = session(buf)
  if s then
    -- the session id changes on /clear and /resume, so keep following it
    st.session_id, st.name, st.cwd = s.sessionId, s.name, s.cwd
    -- only names set with /rename are passed back with --name on restore
    st.named = s.nameSource == "user"
  end
  local status = not running(buf) and "exited" or s and s.status or "starting"
  if st.status == "busy" and status ~= "busy" and not visible(buf) then
    st.unseen = true
    vim.notify(("%s (%s)"):format(M.title(buf), status))
  end
  st.status = status
end

function M.save()
  local agents, starting = {}, 0
  for _, buf in ipairs(M.list()) do
    refresh(buf)
    local st = state[buf]
    if st.status ~= "exited" and st.session_id then
      table.insert(agents, { session_id = st.session_id, cwd = st.cwd or term_cwd(buf), name = st.name, named = st.named })
    elseif st.status == "starting" then
      starting = starting + 1
    end
  end
  vim.fn.mkdir(vim.fs.dirname(M.manifest), "p")
  write_file(M.manifest, vim.json.encode(agents))
  local msg = ("Saved %d agents"):format(#agents)
  if starting > 0 then
    msg = msg .. (", skipped %d still starting up"):format(starting)
  end
  vim.notify(msg)
end

local function tick()
  local bufs = M.list()
  vim.tbl_map(refresh, bufs)
  local labels = table.concat(vim.tbl_map(M.label, bufs), "\n")
  if labels ~= last_labels then
    last_labels = labels
    vim.cmd.redrawtabline()
  end
end

local function blank_tab()
  local buf = vim.api.nvim_get_current_buf()
  return #vim.api.nvim_tabpage_list_wins(0) == 1
    and vim.api.nvim_buf_get_name(buf) == ""
    and vim.bo[buf].buftype == ""
    and not vim.bo[buf].modified
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
end

-- Open an agent in a new tab, running in dir (default: the tab's cwd), resuming
-- saved (an entry from the manifest) if given.
function M.open(dir, saved)
  saved = saved or {}
  -- absolute, as the tcd below changes what a relative path points at
  dir = vim.fs.normalize(vim.fn.fnamemodify(dir or vim.fn.getcwd(), ":p"))
  if not blank_tab() then
    vim.cmd.tabnew()
  end
  vim.cmd("tcd " .. vim.fn.fnameescape(dir))
  local cmd = M.cmd
  if saved.session_id then
    cmd = cmd .. " --resume " .. saved.session_id
  end
  if saved.named then
    cmd = cmd .. " --name " .. vim.fn.shellescape(saved.name)
  end
  -- through an interactive shell so it gets the same environment as one you
  -- type into. The shell execs claude, so the terminal's process is claude.
  vim.fn.jobstart({ vim.o.shell, "-i", "-c", cmd }, { term = true, cwd = dir })
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].claude_agent = true
  state[buf] = { session_id = saved.session_id, name = saved.name, named = saved.named, cwd = dir, status = "starting" }
end

function M.new(dir)
  if dir and vim.fn.isdirectory(vim.fs.normalize(dir)) == 0 then
    vim.notify("Not a directory: " .. dir, vim.log.levels.ERROR)
    return
  end
  M.open(dir)
  vim.cmd.startinsert()
end

function M.new_prompt()
  vim.ui.input({
    prompt = "Agent directory: ",
    default = vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. "/",
    completion = "dir",
  }, function(dir)
    if dir and dir ~= "" then
      M.new(dir)
    end
  end)
end

function M.jump(buf)
  local win = vim.fn.win_findbuf(buf)[1]
  if win then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd("tab sbuffer " .. buf)
  end
end

-- Pick an agent, those that finished while you were away first.
function M.pick()
  local items = {}
  for i, buf in ipairs(M.list()) do
    local st = state[buf] or {}
    table.insert(items, {
      buf = buf,
      text = M.title(buf),
      label = M.label(buf),
      cwd = vim.fn.fnamemodify(st.cwd or term_cwd(buf), ":~"),
      rank = (st.unseen or st.status == "exited") and 0 or st.status == "busy" and 2 or 1,
      order = i,
    })
  end
  table.sort(items, function(a, b)
    return a.rank ~= b.rank and a.rank < b.rank or a.rank == b.rank and a.order < b.order
  end)
  Snacks.picker.pick({
    title = "Claude agents",
    items = items,
    sort = { fields = { "score:desc", "idx" } },
    format = function(item)
      return { { item.label }, { " " }, { item.cwd, "SnacksPickerDir" } }
    end,
    -- copy the text rather than showing the terminal itself, which would resize
    -- claude's pty to the preview window
    preview = function(ctx)
      local lines = vim.api.nvim_buf_get_lines(ctx.item.buf, 0, -1, false)
      while #lines > 0 and lines[#lines]:match("^%s*$") do
        table.remove(lines)
      end
      ctx.preview:reset()
      ctx.preview:set_title(ctx.item.text)
      ctx.preview:set_lines(lines)
      vim.api.nvim_win_set_cursor(ctx.win, { math.max(#lines, 1), 0 })
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        M.jump(item.buf)
      end
    end,
  })
end

function M.restore()
  local agents = read_json(M.manifest)
  if not agents then
    vim.notify("No saved agents in " .. M.manifest, vim.log.levels.WARN)
    return
  end
  -- resuming a session that is still running elsewhere would fork it
  local live = {}
  if vim.fn.isdirectory(M.sessions_dir) == 1 then
    for name in vim.fs.dir(M.sessions_dir) do
      local s = name:match("^%d+%.json$") and read_json(M.sessions_dir .. "/" .. name)
      if s and s.sessionId and vim.uv.kill(s.pid, 0) == 0 then
        live[s.sessionId] = s.pid
      end
    end
  end
  for _, a in ipairs(agents) do
    if live[a.session_id] then
      vim.notify(("%s is already running (pid %d), not restoring it"):format(a.name, live[a.session_id]), vim.log.levels.WARN)
    elseif vim.fn.isdirectory(a.cwd) == 0 then
      vim.notify(("%s: %s no longer exists, not restoring it"):format(a.name, a.cwd), vim.log.levels.WARN)
    else
      M.open(a.cwd, a)
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("ClaudeAgents", {})
  local timer = assert(vim.uv.new_timer())
  timer:start(2000, 2000, vim.schedule_wrap(tick))

  local function seen()
    for _, buf in ipairs(M.list()) do
      if state[buf] and state[buf].unseen and visible(buf) then
        state[buf].unseen = nil
        vim.cmd.redrawtabline()
      end
    end
  end
  vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter" }, { group = group, callback = seen })
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      focused = true
      seen()
    end,
  })
  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      focused = false
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      state[args.buf] = nil
    end,
  })

  vim.api.nvim_create_user_command("AgentsSave", M.save, { desc = "Save the running Claude agents" })
  vim.api.nvim_create_user_command("AgentsRestore", M.restore, { desc = "Resume saved Claude agents" })
  vim.api.nvim_create_user_command("AgentsNew", function(opts)
    M.new(opts.args ~= "" and opts.args or nil)
  end, { nargs = "?", complete = "dir", desc = "Open a Claude agent" })
  vim.api.nvim_create_user_command("Agents", M.pick, { desc = "Pick a Claude agent" })
end

return M
