require "tools"

hs.hotkey.bind(hyper, "q", launchOrCycleFocus("Safari"))
hs.hotkey.bind(hyper, "c", launchOrCycleFocus("Calendar"))
hs.hotkey.bind(hyper, "z", launchOrCycleFocus("Slack"))
hs.hotkey.bind(hyper, "f", launchOrCycleFocus("Finder"))
hs.hotkey.bind(hyper, "m", launchOrCycleFocus("Mail"))
hs.hotkey.bind(hyper, "i", launchOrCycleFocus("Spotify"))
-- hs.hotkey.bind(hyper, "t", launchOrCycleFocus("iTerm"))
hs.hotkey.bind(hyper, "g", launchOrCycleFocus("Tower"))
hs.hotkey.bind(hyper, "d", launchOrCycleFocus("2Do"))
-- hs.hotkey.bind(hyper, "a", launchOrCycleFocus("Bear"))
hs.hotkey.bind(hyper, "x", launchOrCycleFocus("XCode"))
hs.hotkey.bind(hyper, "s", launchOrCycleFocus("Sublime Text"))

-- Reload Hammerspoon config
hs.hotkey.bind(hyperShift, "r", function()
    hs.reload()
    hs.alert.show("Reloaded Hammerspoon configuration")
end)

-- Close notifications
-- script = [[
-- my closeNotif()
-- on closeNotif()
--     tell application "System Events"
--         tell process "Notification Center"
--             set theWindows to every window
--             repeat with i from 1 to number of items in theWindows
--                 set this_item to item i of theWindows
--                 try
--                     click button 1 of this_item
--                 on error
--                     my closeNotif()
--                 end try
--             end repeat
--         end tell
--     end tell
-- end closeNotif ]]
-- function clearNotifications()
--   ok, result = hs.applescript(script)
-- end
-- hs.hotkey.bind(hyper, "c", function()
--   hs.alert.show("Closing notifications")
--   hs.timer.doAfter(0.3, clearNotifications)
-- end)
