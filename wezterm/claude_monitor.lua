local wezterm = require 'wezterm'

-- トークン処理を監視するペインのIDを保持するテーブル
local monitoring_panes = {}

-- ペインの内容をチェックして監視対象の追加/削除を行う共通関数
local function check_pane_content(pane_obj, pane_id, add_only)
  if not pane_obj then
    return
  end
  
  local success, content = pcall(function()
    return pane_obj:get_lines_as_text(10)
  end)
  
  if success and content then
    -- "tokens · esc to interrupt"が含まれているかチェック
    local has_token_text = string.find(content, "tokens · esc to interrupt")
    
    if has_token_text then
      if not monitoring_panes[pane_id] then
        -- 監視対象に追加
        monitoring_panes[pane_id] = true
        wezterm.log_info("🔍 [MONITOR] Added pane " .. pane_id .. " to monitoring list for token processing")
      end
    elseif not add_only and monitoring_panes[pane_id] then
      -- 監視中のペインで"tokens · esc to interrupt"が含まれなくなった（追加専用でない場合のみ）
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
  else
    wezterm.log_info("Error getting pane content for pane " .. pane_id .. ": " .. tostring(content))
  end
end

-- 古いペイン（フォーカスを失ったペイン）の監視対象追加用ラッパー関数
local function monitor_old_pane_content(old_pane_id, new_pane_id, tab, pane)
  local old_mux_pane = wezterm.mux.get_pane(old_pane_id)
  check_pane_content(old_mux_pane, old_pane_id, true) -- 追加専用
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

-- 現在のアクティブペインを監視する関数
local function monitor_active_pane(pane)
  if not pane then
    return
  end
  
  local pane_id = pane:pane_id()
  check_pane_content(pane, pane_id, false) -- 追加と削除の両方
end

return {
  monitor_old_pane_content = monitor_old_pane_content,
  check_monitoring_panes = check_monitoring_panes,
  monitor_active_pane = monitor_active_pane
}