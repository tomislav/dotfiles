local appwindow = nil

local frameCache = {}
local ratioCache = {}
local ratioKeyCache = nil

local centerRatioCache = {}

-- ratios: x, y, w, h, borders: l, r, t, b
local windowFrames = {
	Left	=	{0.0, 0.0, 0.5, 1.0, 00, 2.5, 00, 00},
	Right	=	{0.5, 0.0, 0.5, 1.0, 2.5, 00, 00, 00},
	Up		=	{0.0, 0.0, 1.0, 0.5, 00, 00, 00, 2.5},
	Down	=	{0.0, 0.5, 1.0, 0.5, 00, 00, 2.5, 00}
}

-- ratio adjustments
local ratioAdjustment = {1, 1.3, 0.7}
local centerRatioAdjustment = {0.55, 0.75, 0.35}

local function frameWindow(coords, key)
	return function()
		appwindow = hs.window.frontmostWindow()
		local f = appwindow:frame()
		local max = appwindow:screen():fullFrame()
    local ratioMultipler = nil
    local ratioIndex = nil

    if key == ratioKeyCache and ratioCache[appwindow:id()] then
      ratioIndex = ratioCache[appwindow:id()]
      if (ratioIndex + 1 > #ratioAdjustment) then
        ratioIndex = 1
      else
        ratioIndex = ratioIndex + 1
      end
      ratioMultipler = ratioAdjustment[ratioIndex]
    else
      ratioIndex = 1
      ratioMultipler = ratioAdjustment[ratioIndex]
    end

		if (key == 'Left' or key == 'Right') then
			f.x = (max.x + (max.w * coords[1]) + coords[5]) * (2 - ratioMultipler)
			f.y = max.y + (max.h * coords[2]) + coords[7]
			f.w = math.ceil(((max.w * coords[3]) - coords[7] - coords[6]) * ratioMultipler)
			f.h = math.ceil((max.h * coords[4]) - coords[7] - coords[8])
		else
			f.x = f.x
			f.y = (max.y + (max.h * coords[2]) + coords[7]) * (2 - ratioMultipler)
			f.w = f.w
			f.h = (math.ceil((max.h * coords[4]) - coords[7] - coords[8]) * ratioMultipler)
		end

    appwindow:setFrame(f)

		frameCache[appwindow:id()] = nil
		centerRatioCache[appwindow:id()] = nil
    ratioCache[appwindow:id()] = ratioIndex
    ratioKeyCache = key
	end
end

-- Toggle between different window sizes and snap them to sides
for key, frame in pairs(windowFrames) do
	hs.hotkey.bind(hyperShift, key, frameWindow(frame, key))
end

-- Maximize window or restore previous size
local function maximizeWindow()
	appwindow = hs.window.frontmostWindow()

	if frameCache[appwindow:id()] then
		appwindow:setFrame(frameCache[appwindow:id()])
    frameCache[appwindow:id()] = nil
	else
    frameCache[appwindow:id()] = appwindow:frame()
		local max = appwindow:screen():fullFrame()
	  appwindow:setFrame(max)
	end
end

hs.hotkey.bind(hyper, "ž", maximizeWindow)

-- Center window and toggle between different sizes
function centerWindow()
	appwindow = hs.window.frontmostWindow()
	local f = appwindow:frame()
	local max = appwindow:screen():fullFrame()
	local ratioMultipler = nil
	local ratioIndex = nil

	if centerRatioCache[appwindow:id()] then
		ratioIndex = centerRatioCache[appwindow:id()]
		if (ratioIndex + 1 > #centerRatioAdjustment) then
			ratioIndex = 1
		else
			ratioIndex = ratioIndex + 1
		end
		ratioMultipler = centerRatioAdjustment[ratioIndex]
	else
		ratioIndex = 1
		ratioMultipler = centerRatioAdjustment[ratioIndex]
	end

	f.w = math.ceil(max.w * ratioMultipler)
	f.x = ((max.w - f.w)/2.0)

	appwindow:setFrame(f)

	centerRatioCache[appwindow:id()] = ratioIndex
end

hs.hotkey.bind(hyperShift, "ž", centerWindow)
