local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- keybinds
config.disable_default_key_bindings = true
config.leader = { key="k", mods="CMD", timeout_milliseconds = 2000 }
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.default_prog = { '/opt/homebrew/bin/fish', '-l' }


-- input
config.use_ime = true
-- カラースキームの設定
config.color_scheme = 'Brogrammer'
config.font_size = 16.0
-- Font & Literal
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

config.initial_cols = 1000 -- 最大化
config.initial_rows = 1000 -- 最大化

wezterm.on("bell",function (window,pane)
  window.toast_notification({
"Claude Code",
 "Task completed",
 wezterm.nerdfonts_icon("bell"),4000

  })
end)


return config
