local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 3500

config.window_padding = {
  left = '0cell',
  right = '0cell',
  top = '0cell',
  bottom = '0cell',
}

config.color_scheme = 'Gruvbox Material (Gogh)'
config.font =
  wezterm.font(
    'DinaRemasterII',
    { weight='Regular', stretch='Normal', style='Normal' }
  )
config.font_size = 17.0
config.line_height = 1.0
config.cell_width = 0.9

config.keys = {
  {
    key = 'O',
    mods = 'CTRL',
    action = wezterm.action.QuickSelectArgs {
      label = 'open url',
      patterns = {
        'https?://\\S+',
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    },
  },
}

-- config.visual_bell = {
--   fade_in_function = 'EaseIn',
--   fade_in_duration_ms = 100,
--   fade_out_function = 'EaseOut',
--   fade_out_duration_ms = 100,
-- }
-- config.colors = {
--   visual_bell = '#202020',
-- }

return config
