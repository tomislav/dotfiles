require "tools"

local devApps = { "Atom", "Xcode" }

function modifyKeyPress(tap_event)
  local flags = tap_event:getFlags()
  local character = hs.keycodes.map[tap_event:getKeyCode()]
  local event = nil

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

local key_tap = hs.eventtap.new(
  {hs.eventtap.event.types.keyDown},
  modifyKeyPress
)

-- Define a callback function to be called when application events happen
function applicationWatcherCallback(appName, eventType, appObject)
  -- Switch keyboard layout if developement apps are active
  if (eventType == hs.application.watcher.activated) then
    if (hs.fnutils.contains(devApps, appName)) then
      if not key_tap:isEnabled() then
        key_tap:start()
      end
    else
      if key_tap:isEnabled() then
        key_tap:stop()
      end
    end
  end
end

-- Create and start the application event watcher
local watcher = hs.application.watcher.new(applicationWatcherCallback)
watcher:start()
