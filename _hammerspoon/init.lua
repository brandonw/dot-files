-- ~/.hammerspoon/init.lua

local DISPLAYS = {
  builtin = "37D8832A-2D66-02CA-B9F7-8F30A301B230", -- Built-in Retina
  dell    = "CF60BDDB-9966-4FE3-8672-35A36323EA62", -- DELL U2412M
  lg      = "4FAD2224-7444-4999-B5C5-DC170CD827E7", -- LG HDR 4K
}
local RIFT_CLI = "/opt/homebrew/bin/rift-cli"

local function screenByUUID(uuid)
  for _, s in ipairs(hs.screen.allScreens()) do
    if s:getUUID() == uuid then return s end
  end
  return nil
end

local function warpToScreenCenter(screen)
  local f = screen:fullFrame()
  hs.mouse.absolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end

local function warpToWindow(win)
  local f = win:frame()
  hs.mouse.absolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end

-- Focus the frontmost standard window on the given display and warp the cursor
-- onto it. If the display has no window (bare desktop), just warp to its center.
local function focusDisplay(uuid)
  local screen = screenByUUID(uuid)
  if not screen then
    hs.alert.show("Display not found")
    return
  end

  if hs.mouse.getCurrentScreen() == screen then
    return
  end
  local win = hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return w:screen() == screen and w:isStandard()
  end)
  if win then
    win:focus()
    warpToWindow(win)
  else
    warpToScreenCenter(screen)
  end
end

local function riftSwitchWorkspace(name)
  -- Keys and workspace names are 1-based ("1".."9").
  -- rift-cli takes the 0-based workspace index
  local idx = tostring(tonumber(name) - 1)
  hs.task.new(RIFT_CLI, nil, { "execute", "workspace", "switch", idx }):start()
end

local function threeDisplays()
  return #hs.screen.allScreens() == 3
end

-- Manage rift workspace switching in hammerspoon, since Mac is not good at
-- switching between spaces. We make this more simple with some easy
-- assumptions:
-- If we are docked, then:
--   workspace 8 will always be on the builtin
--   workspace 9 will always be on the dell
--   both will ideally have only one application (window)
--   workspace 1-7 will be on the lg and are where rift actually does work
-- If we are undocked, then we fallback to only switching workspaces, since rift
-- then owns everything.
for i = 1, 7 do
  local name = tostring(i)
  hs.hotkey.bind({ "alt" }, name, function()
    if threeDisplays() then focusDisplay(DISPLAYS.lg) end
    riftSwitchWorkspace(name)
  end)
end

hs.hotkey.bind({ "alt" }, "8", function()
  if threeDisplays() then
    focusDisplay(DISPLAYS.builtin)
  else
    riftSwitchWorkspace("8")
  end
end)

hs.hotkey.bind({ "alt" }, "9", function()
  if threeDisplays() then
    focusDisplay(DISPLAYS.dell)
  else
    riftSwitchWorkspace("9")
  end
end)

-- Warp the cursor to the center of any window that gets activated
-- local wf = hs.window.filter.new(nil)
-- wf:subscribe(hs.window.filter.windowFocused, function(win)
--   if win and win:isStandard() then warpToWindow(win) end
-- end)

-- Auto-reload config on save.
hs.pathwatcher.new(hs.configdir, function(files)
  for _, f in ipairs(files) do
    if f:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end):start()

hs.alert.show("Hammerspoon config loaded")
