local wezterm = require 'wezterm'

-- 前回のアクティブペインを保存する変数
local last_active_pane_id = nil

-- ペインフォーカス変更時のコールバック関数
local pane_focus_callbacks = {}

-- コールバック関数を登録する関数
local function register_pane_focus_callback(callback)
  table.insert(pane_focus_callbacks, callback)
end

-- ペインフォーカス変更ハンドラー
local function pane_focus_changed_handler(tab, pane)
  local current_pane_id = pane.pane_id
  
  if last_active_pane_id and last_active_pane_id ~= current_pane_id and tab.is_active then
    -- 全てのコールバック関数を実行
    for _, callback in ipairs(pane_focus_callbacks) do
      callback(last_active_pane_id, current_pane_id, tab, pane)
    end
    last_active_pane_id = current_pane_id
  elseif tab.is_active and not last_active_pane_id then
    last_active_pane_id = current_pane_id
  end
end

-- デフォルトのログ出力コールバックを登録
register_pane_focus_callback(function(old_pane_id, new_pane_id, tab, pane)
  -- wezterm.log_info("Pane lost focus: " .. old_pane_id .. " -> " .. new_pane_id .. " in tab " .. tab.tab_id)
end)

return {
  register_pane_focus_callback = register_pane_focus_callback,
  pane_focus_changed_handler = pane_focus_changed_handler
}