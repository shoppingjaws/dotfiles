local function pressFn(mods, key)
  if key == nil then
    key = mods
    mods = {}
  end

  return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
  hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

local function remapWithMod(mod, key, replaced)
  remap({ mod }, key, pressFn(replaced))
  remap({ mod, 'shift' }, key, pressFn({ 'shift' }, replaced))
  remap({ mod, 'cmd' }, key, pressFn({ 'cmd' }, replaced))
  remap({ mod, 'alt' }, key, pressFn({ 'alt' }, replaced))
  remap({ mod, 'shift', 'cmd' }, key, pressFn({ 'shift', 'cmd' }, replaced))
  remap({ mod, 'shift', 'alt' }, key, pressFn({ 'shift', 'alt' }, replaced))
  remap({ mod, 'cmd', 'alt' }, key, pressFn({ 'cmd', 'alt' }, replaced))
  remap({ mod, 'cmd', 'alt', 'shift' }, key, pressFn({ 'cmd', 'alt', 'shift' }, replaced))
end


remapWithMod('ctrl', 'j', 'left')
remapWithMod('ctrl', 'k', 'down')
remapWithMod('ctrl', 'i', 'up')
remapWithMod('ctrl', 'l', 'right')
remapWithMod('ctrl', 's', 'delete')
remapWithMod('ctrl', 'd', 'forwarddelete')
remapWithMod('ctrl', 'f', 'return')
hs.hotkey.bind({'ctrl'}, 'w', pressFn('escape'), nil, pressFn('escape'))

