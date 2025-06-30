local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- keybinds
config.automatically_reload_config = true
config.disable_default_key_bindings = true
config.leader = { key="k", mods="CMD", timeout_milliseconds = 2000 }
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.scrollback_lines = 100000
config.enable_scroll_bar = true
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.default_prog = { '/opt/homebrew/bin/fish', '-l' }

config.colors = require("colors").Brogrammer
config.use_ime = true
config.font_size = 16.0
-- Font & Literal
config.font = wezterm.font_with_fallback({
  {family="0xProto"},
  {family="Source Han Code JP"},
})
config.window_background_opacity = 0.85
config.use_ime = true
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.audible_bell = "SystemBeep"

config.initial_cols = 1000 -- 最大化
config.initial_rows = 1000 -- 最大化

-- アクティブなペインの境界線の色設定
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.5,
}

local claude_monitor = require("claude_monitor")

-- 右ステータス更新時に監視ペインの状態とアクティブペインをチェック
wezterm.on("update-right-status", function(window, pane)
  claude_monitor.check_monitoring_panes()
  claude_monitor.monitor_active_pane(pane)
end)

-- タブタイトルをカレントディレクトリにする
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  
  local cwd = pane.current_working_dir
  if cwd then
    -- URLからパスを取得
    local path = cwd.file_path
    -- ホームディレクトリを ~ に置換
    path = path:gsub("^" .. os.getenv("HOME"), "~")
    -- 最後のディレクトリ名だけを取得
    local basename = path:match("([^/]+)/?$") or path
    -- 32文字に固定（パディングで調整）
    local title = " " .. basename .. " "
    if #title < 32 then
      local padding = math.floor((32 - #title) / 2)
      title = string.rep(" ", padding) .. title .. string.rep(" ", 32 - #title - padding)
    elseif #title > 32 then
      title = string.sub(title, 1, 32)
    end
    return {
      { Text = title },
    }
  end
  
  return tab.active_pane.title
end)


return config
