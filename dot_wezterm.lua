local wezterm = require 'wezterm'
local helpers = require 'helpers'

local config = wezterm.config_builder()

-- helpers.apply_to_config(config)

-- カラースキームの設定
config.color_scheme = 'Brogrammer'
config.font_size = 16.0
-- Font & Literal
config.font = wezterm.font("SauceCodePro Nerd Font Mono")
config.window_background_opacity = 0.85
config.use_ime = true
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.audible_bell = "VisualBell"
config.visual_bell = {
  fade_in_duration_ms = 150,
  fade_out_duration_ms = 150,
  target = "CursorColor",
},

-- Key Binding

return config
