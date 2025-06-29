local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Pane monitoring state
local monitored_panes = {}
local current_active_pane_id = nil

-- Function to send WezTerm toast notification
local function send_notification(window, pane_id, message)
  window:toast_notification("WezTerm Monitor", message .. " (Pane " .. tostring(pane_id) .. ")", nil, 4000)
end

-- Function to check if pane contains the target string
local function pane_contains_tokens(pane)
  local text = pane:get_logical_lines_as_text(10)
  return string.find(text, "tokens · esc to interrupt") ~= nil
end

-- Function to check a specific pane for token completion
local function check_pane_tokens(window, pane)
  local pane_id = pane:pane_id()
  local has_tokens = pane_contains_tokens(pane)
  
  if has_tokens then
    -- If this is a new pane with tokens, add it to monitoring
    if not monitored_panes[pane_id] then
      monitored_panes[pane_id] = true
      wezterm.log_info("Claude Code task detected in pane " .. tostring(pane_id))
    end
  else
    -- If pane was previously monitored but no longer has tokens, send notification
    if monitored_panes[pane_id] then
      wezterm.log_info("Claude Code task finished in pane " .. tostring(pane_id))
      send_notification(window, pane_id, "Tokens processing completed!")
      monitored_panes[pane_id] = nil
    end
  end
end

-- Function to get pane by ID from current tab
local function get_pane_by_id(tab, target_pane_id)
  local panes = tab:panes()
  for _, pane in ipairs(panes) do
    if pane:pane_id() == target_pane_id then
      return pane
    end
  end
  return nil
end

-- Focus-based monitoring function (much more efficient)
local function monitor_pane_focus_changes(window, pane)
  local active_pane_id = pane:pane_id()
  -- Check if active pane has changed
  if current_active_pane_id ~= active_pane_id then
    -- If we had a previous active pane, check if it completed tokens processing
    if current_active_pane_id then
      -- wezterm.log_info("Pane " .. tostring(current_active_pane_id) .. " lost focus")
      local tab = pane:tab()
      local previous_pane = get_pane_by_id(tab, current_active_pane_id)
      if previous_pane then
        check_pane_tokens(window, previous_pane)
      end
    end
    
    -- Update current active pane
    current_active_pane_id = active_pane_id
    -- wezterm.log_info("Pane " .. tostring(active_pane_id) .. " gained focus")
    
    -- Also check the new active pane for tokens (to detect new tasks)
    check_pane_tokens(window, pane)
  end
end

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
  {family="Utatane"},
  {family="Symbols Nerd Font Mono", scale=1.0}
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

-- Monitor pane focus changes for "tokens · esc to interrupt" (performance optimized)
-- Note: format-window-title doesn't provide window object, so we use update-right-status
wezterm.on("update-right-status", function(window, pane)
  monitor_pane_focus_changes(window, pane)
end)

return config
