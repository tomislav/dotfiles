require "tools"

local devApps = { "Atom", "Xcode", "iTerm2" }

function modifyKeyPress(tap_event)
  local flags = tap_event:getFlags()
  local character = hs.keycodes.map[tap_event:getKeyCode()]
  local event = nil

  -- for k, v in pairs( flags ) do
  --    print(k, v)
  -- end

  if (flags.cmd and flags.ctrl and flags.alt) then return false end

  if (character == "š") then
    if (flags.shift) then
      event = hs.eventtap.event.newKeyEvent({"alt", "shift"}, "š", true)
    elseif (flags.cmd) then
      event = hs.eventtap.event.newKeyEvent({"alt", "cmd"}, "š", true)
    else
      event = hs.eventtap.event.newKeyEvent({"alt"}, "š", true)
    end
  elseif (character == "đ") then
    if (flags.shift) then
      event = hs.eventtap.event.newKeyEvent({"alt", "shift"}, "đ", true)
    elseif (flags.cmd) then
      event = hs.eventtap.event.newKeyEvent({"alt", "cmd"}, "đ", true)
    else
      event = hs.eventtap.event.newKeyEvent({"alt"}, "đ", true)
    end
  elseif (character == "ž") then
    if (flags.shift) then
      event = hs.eventtap.event.newKeyEvent({"alt", "shift"}, "ž", true)
    else
      event = hs.eventtap.event.newKeyEvent({"alt"}, "ž", true)
    end
  elseif (character == "ć") then
    if (flags.shift) then
      event = hs.eventtap.event.newKeyEvent({"shift"}, "2", true)
    else
      event = hs.eventtap.event.newKeyEvent({"shift"}, "7", true)
    end
  elseif (character == "č") then
    if (flags.shift) then
      event = hs.eventtap.event.newKeyEvent({"alt", "shift"}, "2", true)
    else
      event = hs.eventtap.event.newKeyEvent({"shift"}, ",", true)
    end
  end
  if (event) then
    return true, {event}
  else
    return false
  end
end

devkey_key_tap = hs.eventtap.new(
  {hs.eventtap.event.types.keyDown},
  modifyKeyPress
)

-- Define a callback function to be called when application events happen
function applicationWatcherCallback(appName, eventType, appObject)
  -- Switch keyboard layout if developement apps are active
  if (eventType == hs.application.watcher.activated) then
    dbgf("devkeyboard: %s activated", appName)
    if (hs.fnutils.contains(devApps, appName)) then
      if not devkey_key_tap:isEnabled() then
        dbg("devkeyboard: enabling keyboard")
        devkey_key_tap:start()
      end
    else
      if devkey_key_tap:isEnabled() then
        dbg("devkeyboard: disabling keyboard")
        devkey_key_tap:stop()
      end
    end
  end
end

-- Define a callback function to be called when system wake/sleep events happen
function caffeinateWatcherCallback(event)
  -- Switch keyboard layout if developement apps are active
  if (event == hs.caffeinate.watcher.systemDidWake) then
    dbg("devkeyboard: resuming")
    devKeyboardWatcher:start()
  elseif (event == hs.caffeinate.watcher.systemWillSleep) then
    devKeyboardWatcher:stop()
    dbg("devkeyboard: stopped")
  end
end

-- Create and start the application event watcher
devKeyboardWatcher = hs.application.watcher.new(applicationWatcherCallback)
devKeyboardWatcher:start()

-- Create a caffeinate watcher to start/stop the task on system wake/sleep events
caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateWatcherCallback)
caffeinateWatcher:start()

dbg("devkeyboard: started")
