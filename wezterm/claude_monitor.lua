local wezterm = require 'wezterm'

-- デバッグフラグ
local DEBUG = true

-- トークン処理を監視するペインのIDを保持するテーブル
local monitoring_panes = {}

-- タイマーID
local timer_id = nil

-- デバッグログ関数
local function debug_log(message)
  if DEBUG then
    wezterm.log_info(message)
  end
end

-- ペインの内容をチェックして監視対象の追加/削除を行う共通関数
local function check_pane_content(pane_obj, pane_id, add_only)
  debug_log("[DEBUG] check_pane_content called for pane " .. pane_id .. ", add_only=" .. tostring(add_only))
  if not pane_obj then
    debug_log("[DEBUG] pane_obj is nil for pane " .. pane_id)
    return
  end
  
  local success, content = pcall(function()
    return pane_obj:get_lines_as_text(10)
  end)
  
  if success and content then
    debug_log("[DEBUG] Got content for pane " .. pane_id .. ", length=" .. string.len(content))
    -- "tokens · esc to interrupt"が含まれているかチェック
    local has_token_text = string.find(content, "tokens · esc to interrupt")
    debug_log("[DEBUG] has_token_text=" .. tostring(has_token_text) .. " for pane " .. pane_id)
    
    if has_token_text then
      if not monitoring_panes[pane_id] then
        -- 監視対象に追加
        monitoring_panes[pane_id] = true
        wezterm.log_info("🔍 [MONITOR] Added pane " .. pane_id .. " to monitoring list for token processing")
      else
        debug_log("[DEBUG] Pane " .. pane_id .. " already in monitoring list")
      end
    elseif not add_only and monitoring_panes[pane_id] then
      -- 監視中のペインで"tokens · esc to interrupt"が含まれなくなった（追加専用でない場合のみ）
      monitoring_panes[pane_id] = nil
      wezterm.log_info("[MONITOR] Removed pane " .. pane_id .. " from monitoring list - token processing completed")

      -- トースト通知を送信
      wezterm.gui.gui_windows()[1]:toast_notification(
        "Claude Code",
        "Task completed",
        nil,
        4000
      )
    else
      debug_log("[DEBUG] No action needed for pane " .. pane_id .. " (add_only=" .. tostring(add_only) .. ", monitored=" .. tostring(monitoring_panes[pane_id] ~= nil) .. ")")
    end
  else
    debug_log("[DEBUG] Error getting pane content for pane " .. pane_id .. ": " .. tostring(content))
  end
end

-- 全ペインをスキャンして監視対象を追加する関数
local function scan_all_panes_for_monitoring()
  debug_log("🔎 [DEBUG] scan_all_panes_for_monitoring started")
  local pane_count = 0
  for _, window in ipairs(wezterm.mux.all_windows()) do
    for _, tab in ipairs(window:tabs()) do
      for _, pane in ipairs(tab:panes()) do
        local pane_id = pane:pane_id()
        pane_count = pane_count + 1
        debug_log("[DEBUG] Scanning pane " .. pane_id)
        check_pane_content(pane, pane_id, true) -- 追加専用
      end
    end
  end
end

-- ウィンドウフォーカス喪失時にすべてのペインをチェック
local function on_window_focus_lost()
  debug_log("[DEBUG] on_window_focus_lost called")
  scan_all_panes_for_monitoring()
end

-- 古いペイン（フォーカスを失ったペイン）の監視対象追加用ラッパー関数
local function monitor_old_pane_content(old_pane_id, new_pane_id, tab, pane)
  debug_log("[DEBUG] monitor_old_pane_content called: old_pane_id=" .. old_pane_id .. ", new_pane_id=" .. new_pane_id)
  local old_mux_pane = wezterm.mux.get_pane(old_pane_id)
  check_pane_content(old_mux_pane, old_pane_id, true) -- 追加専用
end

-- 監視中のペインの状態をチェックする関数
local function check_monitoring_panes()
  local monitoring_count = 0
  for pane_id, _ in pairs(monitoring_panes) do
    monitoring_count = monitoring_count + 1
  end
  
  for pane_id, _ in pairs(monitoring_panes) do
    debug_log("[DEBUG] Checking monitored pane " .. pane_id)
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
      local has_token_text = string.find(result, "tokens · esc to interrupt")
      if not has_token_text then
        -- 監視対象から除外
        monitoring_panes[pane_id] = nil
        wezterm.log_info("[MONITOR] Removed pane " .. pane_id .. " from monitoring list - token processing completed")

        -- トースト通知を送信
        wezterm.gui.gui_windows()[1]:toast_notification(
          "Claude Code",
          "Task completed",
          nil,
          4000
        )
      end
    elseif success and not result then
      -- ペインが存在しなくなった場合は監視対象から除外
      monitoring_panes[pane_id] = nil
      wezterm.log_info("[MONITOR] Removed pane " .. pane_id .. " from monitoring list - pane no longer exists")
    else
      wezterm.log_info("❌ [MONITOR] Error checking monitored pane " .. pane_id .. ": " .. tostring(result))
    end
  end
end

-- 現在のアクティブペインを監視する関数
local function monitor_active_pane(pane)
  if not pane then
    debug_log("[DEBUG] monitor_active_pane called with nil pane")
    return
  end
  
  local pane_id = pane:pane_id()
  debug_log("[DEBUG] monitor_active_pane called for pane " .. pane_id)
  check_pane_content(pane, pane_id, false) -- 追加と削除の両方
end

-- 毎秒監視を開始する関数
local function start_monitoring()
  if timer_id then
    debug_log("[DEBUG] start_monitoring called but already running")
    return -- 既に開始済み
  end
  
  debug_log("[DEBUG] start_monitoring: Starting timer")
  timer_id = wezterm.time.call_after(1, function()
    check_monitoring_panes()
    timer_id = nil
    start_monitoring() -- 再帰的に1秒後に実行
  end)
end

-- 初期化時に監視を開始
debug_log("[DEBUG] claude_monitor.lua loaded, initializing...")
start_monitoring()

return {
  monitor_old_pane_content = monitor_old_pane_content,
  check_monitoring_panes = check_monitoring_panes,
  monitor_active_pane = monitor_active_pane,
  scan_all_panes_for_monitoring = scan_all_panes_for_monitoring,
  on_window_focus_lost = on_window_focus_lost,
  start_monitoring = start_monitoring,
}