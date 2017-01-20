local spaces = require('hs._asm.undocumented.spaces')
local cache  = {}

local waitForAnimation = function(targetSpace, changedFocus, mousePosition)
  if cache.waiting then return end
  cache.changeStart = hs.timer.secondsSinceEpoch()

  -- wait for switching to end (spaces.isAnimating() doesn't work for me)
  -- and move cursor back to original position
  cache.waiting = hs.timer.waitUntil(
    function()
      return (spaces.activeSpace() == targetSpace) or (hs.timer.secondsSinceEpoch() - cache.changeStart > 2)
    end,
    function()
      if changedFocus then
        hs.mouse.setAbsolutePosition(mousePosition)
      end

      cache.changeStart = nil
      cache.switching   = false
      cache.waiting     = nil
    end,
    0.01
  )
end

-- sends proper amount of ctrl+left/right to move you to given space, even if it's fullscreen app!
function switchToIndex(targetIdx)
  -- save mouse pointer to reset after switch is done
  local mousePosition = hs.mouse.getAbsolutePosition()

  -- grab spaces for screen with active window
  local currentScreen = activeScreen()
  local screenSpaces  = screenSpaces(currentScreen)

  -- gain focus on the screen
  local changedFocus = focusScreen(currentScreen)

  -- grab index of currently active space
  local activeIdx     = activeSpaceIndex(screenSpaces)
  local targetSpace   = spaceFromIndex(targetIdx)

  -- check if we really can send the keystrokes
  local shouldSendEvents = hs.fnutils.every({
    not cache.switching,
    targetSpace,
    activeIdx ~= targetIdx,
    targetIdx <= #screenSpaces,
    targetIdx >= 1
  }, function(test) return test end)

  if shouldSendEvents then
    cache.switching = true
    local eventCount     = math.abs(targetIdx - activeIdx)
    local eventDirection = targetIdx > activeIdx and 'right' or 'left'

    for _ = 1, eventCount do
      -- not using keyStroke because it's slow now
      hs.eventtap.event.newKeyEvent({ 'ctrl' }, eventDirection, true):post()
      hs.eventtap.event.newKeyEvent({ 'ctrl' }, eventDirection, false):post()
    end

    waitForAnimation(targetSpace, changedFocus, mousePosition)
  end
end

function switchInDirection(direction)
  local currentScreen = activeScreen()
  local mousePosition = hs.mouse.getAbsolutePosition()
  local targetSpace   = spaceInDirection(direction)

  -- gain focus on the screen
  local changedFocus = focusScreen(currentScreen)
  waitForAnimation(targetSpace, changedFocus, mousePosition)
end

local spacesEventTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local keyCode   = event:getKeyCode()
  local modifiers = event:getFlags()
  local isCtrl    = #keys(modifiers) == 1 and modifiers.ctrl
  local isCtrlFn  = #keys(modifiers) == 2 and modifiers.ctrl and modifiers.fn
  local targetIdx = tonumber(event:getCharacters())

  -- switch to index if it's ctrl + 0-9
  if isCtrl and targetIdx then
    switchToIndex(targetIdx)
    return true
  end

  -- switch left/right if it's ctrl + left(123)/right(124)
  if isCtrlFn and (keyCode == 123 or keyCode == 124) then
    local currentIdx  = activeSpaceIndex(screenSpaces(activeScreen()))
    local lastIdx = #screenSpaces(activeScreen())
    -- check if we're the first or last screen and enable circular switching
    if (currentIdx == 1 and keyCode == 123) then
      switchToIndex(lastIdx)
      return true
    elseif (currentIdx == lastIdx and keyCode == 124) then
      switchToIndex(1)
      return true
    else
      switchInDirection(keyCode == 123 and 'west' or 'east')
      return false
    end
  end

  -- propagate everything else back to the system
  return false
end):start()

hs.hotkey.bind(hyperShift, "+", function()
  -- this is to bind the spacesEventTap variable to a long-lived function in
  -- order to prevent GC from doing their evil business
  hs.alert.show("Fast space switching enabled: " .. tostring(spacesEventTap:isEnabled()))
end)

function spaceInDirection(direction)
  local screenSpaces = screenSpaces()
  local activeIdx    = activeSpaceIndex(screenSpaces)
  local targetIdx    = direction == 'west' and activeIdx - 1 or activeIdx + 1

  return screenSpaces[targetIdx]
end

function activeSpaceIndex(screenSpaces)
  return hs.fnutils.indexOf(screenSpaces, spaces.activeSpace()) or 1
end

function screenSpaces(currentScreen)
  currentScreen = currentScreen or activeScreen()
  return spaces.layout()[currentScreen:spacesUUID()]
end

function isSpaceFullscreenApp(spaceID)
  return spaceID ~= nil and #spaces.spaceOwners(spaceID) > 0
end

function spaceFromIndex(index)
  local currentScreen = activeScreen()
  return screenSpaces(currentScreen)[index]
end

-- grabs screen with active window, unless it's Finder's desktop
-- then we use mouse position
function activeScreen()
  local mousePoint   = hs.geometry.point(hs.mouse.getAbsolutePosition())
  local activeWindow = hs.window.focusedWindow()

  if activeWindow and activeWindow:role() ~= 'AXScrollArea' then
    return activeWindow:screen()
  else
    return hs.fnutils.find(hs.screen.allScreens(), function(screen)
      return mousePoint:inside(screen:frame())
    end)
  end
end

function focusScreen(screen)
  local frame         = screen:frame()
  local mousePosition = hs.mouse.getAbsolutePosition()

  -- if mouse is already on the given screen we can safely return
  if hs.geometry(mousePosition):inside(frame) then return false end

  -- "hide" cursor in the lower right side of screen
  -- it's invisible while we are changing spaces
  local newMousePosition = {
    x = frame.x + frame.w - 1,
    y = frame.y + frame.h - 1
  }

  hs.mouse.setAbsolutePosition(newMousePosition)
  hs.timer.usleep(1000)

  return true
end
