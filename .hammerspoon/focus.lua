-- Focus windows
hs.hotkey.bind(hyper, "up", function() hs.window.focusedWindow():focusWindowNorth(nil, true) end)
hs.hotkey.bind(hyper, "right", function() hs.window.focusedWindow():focusWindowEast(nil, true) end)
hs.hotkey.bind(hyper, "down", function() hs.window.focusedWindow():focusWindowSouth(nil, true) end)
hs.hotkey.bind(hyper, "left", function() hs.window.focusedWindow():focusWindowWest(nil, true) end)
