local wezterm = require 'wezterm'

-- トークン処理を監視するペインのIDを保持するテーブル
local monitoring_panes = {}

-- 古いペイン（フォーカスを失ったペイン）の文字列を10行取得して監視対象に追加する関数
local function monitor_old_pane_content(old_pane_id, new_pane_id, tab, pane)
  -- 古いペイン（フォーカスを失ったペイン）の情報を取得
  local success, result = pcall(function()
    local old_mux_pane = wezterm.mux.get_pane(old_pane_id)
    if old_mux_pane then
      return old_mux_pane:get_lines_as_text(10)
    else
      return "Could not get old mux pane"
    end
  end)
  
  if success then
    -- wezterm.log_info("Old pane content (10 lines): " .. result)
    
    -- "tokens · esc to interrupt"が含まれているかチェック（追加のみ）
    if string.find(result, "tokens · esc to interrupt") then
      if not monitoring_panes[old_pane_id] then
        -- 監視対象に追加
        monitoring_panes[old_pane_id] = true
        wezterm.log_info("🔍 [MONITOR] Added pane " .. old_pane_id .. " to monitoring list for token processing")
      end
    end
  else
    wezterm.log_info("Error getting old pane text: " .. tostring(result))
  end
end

-- 監視中のペインの状態をチェックする関数
local function check_monitoring_panes()
  for pane_id, _ in pairs(monitoring_panes) do
    local success, result = pcall(function()
      local mux_pane = wezterm.mux.get_pane(pane_id)
      if mux_pane then
        return mux_pane:get_lines_as_text(10)
      else
        return nil
      end
    end)
    
    if success and result then
      -- "tokens · esc to interrupt"が含まれなくなったかチェック
      if not string.find(result, "tokens · esc to interrupt") then
        -- 監視対象から除外
        monitoring_panes[pane_id] = nil
        wezterm.log_info("✅ [MONITOR] Removed pane " .. pane_id .. " from monitoring list - token processing completed")
        
        -- トースト通知を送信
        wezterm.gui.gui_windows()[1]:toast_notification(
          "Claude Code",
          "Token processing completed in pane " .. pane_id,
          nil,
          4000
        )
      end
    elseif success and not result then
      -- ペインが存在しなくなった場合は監視対象から除外
      monitoring_panes[pane_id] = nil
      wezterm.log_info("🗑️ [MONITOR] Removed pane " .. pane_id .. " from monitoring list - pane no longer exists")
    end
  end
end

return {
  monitor_old_pane_content = monitor_old_pane_content,
  check_monitoring_panes = check_monitoring_panes
}