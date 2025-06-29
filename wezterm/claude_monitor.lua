local wezterm = require 'wezterm'

-- Configuration
local CONFIG = {
  DEBUG = false,
  TIMER_INTERVAL = 10, -- seconds
  NOTIFICATION_DURATION = 4000, -- milliseconds
  PANE_LINES_TO_CHECK = 10,
  TOKEN_PATTERN = "tokens · esc to interrupt"
}

-- State
local monitoring_panes = {}
local timer_id = nil

-- Utility functions
local function debug_log(message)
  if CONFIG.DEBUG then
    wezterm.log_info(message)
  end
end

local function send_completion_notification()
  local gui_windows = wezterm.gui.gui_windows()
  if #gui_windows > 0 then
    gui_windows[1]:toast_notification(
      "Claude Code",
      "Task completed",
      nil,
      CONFIG.NOTIFICATION_DURATION
    )
  end
end

local function get_pane_content(pane_obj)
  if not pane_obj then
    return nil
  end
  
  local success, content = pcall(function()
    return pane_obj:get_lines_as_text(CONFIG.PANE_LINES_TO_CHECK)
  end)
  
  return success and content or nil
end

local function has_token_pattern(content)
  return content and string.find(content, CONFIG.TOKEN_PATTERN) ~= nil
end

-- Core monitoring functions
local function add_pane_to_monitoring(pane_id)
  if monitoring_panes[pane_id] then
    debug_log("[DEBUG] Pane " .. pane_id .. " already in monitoring list")
    return
  end
  
  monitoring_panes[pane_id] = true
  wezterm.log_info("🔍 [MONITOR] Added pane " .. pane_id .. " to monitoring list for token processing")
end

local function remove_pane_from_monitoring(pane_id, reason)
  if not monitoring_panes[pane_id] then
    return
  end
  
  monitoring_panes[pane_id] = nil
  wezterm.log_info("[MONITOR] Removed pane " .. pane_id .. " from monitoring list - " .. (reason or "token processing completed"))
  
  if reason == "token processing completed" or not reason then
    send_completion_notification()
  end
end

local function check_pane_content(pane_obj, pane_id, add_only)
  debug_log("[DEBUG] check_pane_content called for pane " .. pane_id .. ", add_only=" .. tostring(add_only))
  if not pane_obj then
    debug_log("[DEBUG] pane_obj is nil for pane " .. pane_id)
    return
  end
  
  local content = get_pane_content(pane_obj)
  if not content then
    debug_log("[DEBUG] Error getting pane content for pane " .. pane_id)
    return
  end
  
  debug_log("[DEBUG] Got content for pane " .. pane_id .. ", length=" .. string.len(content))
  local has_tokens = has_token_pattern(content)
  debug_log("[DEBUG] has_token_text=" .. tostring(has_tokens) .. " for pane " .. pane_id)
  
  if has_tokens then
    add_pane_to_monitoring(pane_id)
  elseif not add_only and monitoring_panes[pane_id] then
    remove_pane_from_monitoring(pane_id, "token processing completed")
  else
    debug_log("[DEBUG] No action needed for pane " .. pane_id .. " (add_only=" .. tostring(add_only) .. ", monitored=" .. tostring(monitoring_panes[pane_id] ~= nil) .. ")")
  end
end

-- Pane scanning functions
local function scan_all_panes_for_monitoring()
  debug_log("🔎 [DEBUG] scan_all_panes_for_monitoring started")
  
  for _, window in ipairs(wezterm.mux.all_windows()) do
    for _, tab in ipairs(window:tabs()) do
      for _, pane in ipairs(tab:panes()) do
        local pane_id = pane:pane_id()
        debug_log("[DEBUG] Scanning pane " .. pane_id)
        check_pane_content(pane, pane_id, true)
      end
    end
  end
  
  debug_log("[DEBUG] scan_all_panes_for_monitoring completed")
end

-- Event handlers
local function on_window_focus_lost()
  debug_log("[DEBUG] on_window_focus_lost called")
  scan_all_panes_for_monitoring()
end

local function monitor_old_pane_content(old_pane_id, new_pane_id, tab, pane)
  debug_log("[DEBUG] monitor_old_pane_content called: old_pane_id=" .. old_pane_id .. ", new_pane_id=" .. new_pane_id)
  local old_mux_pane = wezterm.mux.get_pane(old_pane_id)
  check_pane_content(old_mux_pane, old_pane_id, true)
end

local function check_monitoring_panes()
  local panes_to_remove = {}
  
  for pane_id, _ in pairs(monitoring_panes) do
    debug_log("[DEBUG] Checking monitored pane " .. pane_id)
    
    local mux_pane = wezterm.mux.get_pane(pane_id)
    if not mux_pane then
      table.insert(panes_to_remove, {pane_id, "pane no longer exists"})
    else
      local content = get_pane_content(mux_pane)
      if content then
        if not has_token_pattern(content) then
          table.insert(panes_to_remove, {pane_id, "token processing completed"})
        end
      else
        wezterm.log_info("❌ [MONITOR] Error checking monitored pane " .. pane_id)
      end
    end
  end
  
  -- Remove panes after iteration to avoid modifying table during iteration
  for _, pane_info in ipairs(panes_to_remove) do
    remove_pane_from_monitoring(pane_info[1], pane_info[2])
  end
end

local function monitor_active_pane(pane)
  if not pane then
    debug_log("[DEBUG] monitor_active_pane called with nil pane")
    return
  end
  
  local pane_id = pane:pane_id()
  debug_log("[DEBUG] monitor_active_pane called for pane " .. pane_id)
  check_pane_content(pane, pane_id, false)
end

-- Timer management
local function start_monitoring()
  if timer_id then
    debug_log("[DEBUG] start_monitoring called but already running")
    return
  end
  
  debug_log("[DEBUG] start_monitoring: Starting timer")
  timer_id = wezterm.time.call_after(CONFIG.TIMER_INTERVAL, function()
    check_monitoring_panes()
    timer_id = nil
    start_monitoring()
  end)
end

-- Initialization
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