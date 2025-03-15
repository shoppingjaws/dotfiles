local wezterm = require 'wezterm'

local config = wezterm.config_builder()


-- カラースキームの設定
config.color_scheme = 'Brogrammer'
config.font_size = 16.0
-- Font & Literal
-- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/UbuntuMono.zip
-- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/SourceCodePro.zip
config.font = wezterm.font_with_fallback({"UbuntuMono Nerd Font Mono","SauceCodePro Nerd Font Mono"})
config.window_background_opacity = 0.85
config.use_ime = true
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 150,
  fade_out_duration_ms = 150,
  target = "CursorColor",
}


return config
