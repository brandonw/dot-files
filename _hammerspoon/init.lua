-- ~/.hammerspoon/init.lua
--
-- Per-display keyboard focus + cursor warp.
--   ⌃⌘1 = DELL U2412M (left)   ⌃⌘2 = LG HDR 4K (right)   ⌃⌘3 = Built-in Retina
-- (Ctrl+1/2/3 is reserved by macOS Mission Control "Switch to Desktop" and
--  can't be claimed via RegisterEventHotKey, so we use Ctrl+Cmd instead.)
local DISPLAYS = {
  dell    = "CF60BDDB-9966-4FE3-8672-35A36323EA62", -- DELL U2412M  (left)
  builtin = "37D8832A-2D66-02CA-B9F7-8F30A301B230", -- Built-in Retina
  lg      = "4FAD2224-7444-4999-B5C5-DC170CD827E7", -- LG HDR 4K   (right)
}

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

-- ⌃⌘1/2/3 focus that display and warp the cursor onto it.
local MOD = { "ctrl", "cmd" }
hs.hotkey.bind(MOD, "1", function() focusDisplay(DISPLAYS.dell) end)
hs.hotkey.bind(MOD, "2", function() focusDisplay(DISPLAYS.lg) end)
hs.hotkey.bind(MOD, "3", function() focusDisplay(DISPLAYS.builtin) end)

-- Warp the cursor to the center of any window that gets activated, however the
-- activation happened (⌃⌘1/2/3, cmd-tab, cmd-`, or even a mouse click).
local wf = hs.window.filter.new(nil)
wf:subscribe(hs.window.filter.windowFocused, function(win)
  if win and win:isStandard() then warpToWindow(win) end
end)

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
