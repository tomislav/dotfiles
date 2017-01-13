-- Hold Cmd+Q to quit

local x = 0;
local didQuit = false

local function keyHold()
    if not didQuit then
      x = x + 1
      if (x == 6) then
        hs.application.frontmostApplication():selectMenuItem("^Quit.*$")
        didQuit = true
        x = 0;
      end
    end
end

hs.hotkey.bind('cmd', 'q', nil, function() didQuit = false end, function() keyHold() end)
