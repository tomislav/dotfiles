hyper = {"ctrl", "alt", "cmd"}
hyperFn = {"ctrl", "alt", "cmd", "fn"}
hyperShift = {"ctrl", "alt", "cmd", "shift"}
hyperShiftFn = {"ctrl", "alt", "cmd", "shift", "fn"}

display_laptop = "Color LCD"
display_monitor1 = "LG Ultrafine 5K"

hs.window.animationDuration = 0

require 'localassets'
require 'window'
require 'focus'
require 'battery'
-- require 'cheatsheet'
-- require 'spaces'
require 'keybindings'
require 'itunes'

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

Install:andUse("UniversalArchive",
{
   config = {
      archive_notifications = false
   },
   hotkeys = { archive = { { "ctrl", "cmd", "option" }, "a" } }
})
