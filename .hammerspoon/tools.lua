local fnutils = require "hs.fnutils"
local filter = fnutils.filter
local indexOf = fnutils.indexOf

-- Debugging

dbg = function(...)
  print(hs.inspect(...))
end

dbgf = function (...)
  return dbg(string.format(...))
end

function tap (a)
  dbg(a)
  return a
end

-- Window stuff

function launchOrToggle(applicationName)
  return function()
    local app = hs.application.find(applicationName)
    if not app or app:isHidden() then
        hs.application.launchOrFocus(applicationName)
    elseif hs.application.frontmostApplication() ~= app then
        app:activate()
    else
        app:hide()
    end
  end
end

function launchOrToggleByBundleId(bundleId)
  return function()
    local app = hs.application.find(bundleId)
    if not app or app:isHidden() then
        hs.application.launchOrFocusByBundleID(bundleId)
    elseif hs.application.frontmostApplication() ~= app then
        app:activate()
    else
        app:hide()
    end
  end
end

lastToggledApplication = ''

function launchOrCycleFocus(applicationName)
  return function()
    local nextWindow = nil
    local targetWindow = nil
    local focusedWindow          = hs.window.focusedWindow()
    local lastToggledApplication = focusedWindow and focusedWindow:application():title()

    if not focusedWindow then return nil end

    if lastToggledApplication == applicationName then
      nextWindow = getNextWindow(applicationName, focusedWindow)
      nextWindow:becomeMain()
    else
      hs.application.launchOrFocus(applicationName)
    end

    if nextWindow then -- won't be available when appState empty
      targetWindow = nextWindow
    else
      targetWindow = hs.window.focusedWindow()
    end

    if not targetWindow then
      -- dbgf('failed finding a window for application: %s', applicationName)
      return nil
    end
  end
end


function getNextWindow(windows, window)
  if type(windows) == "string" then
    windows = hs.appfinder.appFromName(windows):allWindows()
  end

  windows = filter(windows, hs.window.isStandard)
  windows = filter(windows, hs.window.isVisible)

  -- need to sort by ID, since the default order of the window
  -- isn't usable when we change the mainWindow
  -- since mainWindow is always the first of the windows
  -- hence we would always get the window succeeding mainWindow
  table.sort(windows, function(w1, w2)
    return w1:id() > w2:id()
  end)

  lastIndex = indexOf(windows, window)

  return windows[getNextIndex(windows, lastIndex)]
end

---------------------------------------------------------
-- COORDINATES, POINTS, RECTS, FRAMES, TABLES
---------------------------------------------------------

-- Fetch next index but cycle back when at the end
--
-- > getNextIndex({1,2,3}, 3)
-- 1
-- > getNextIndex({1}, 1)
-- 1
-- @return int
function getNextIndex(table, currentIndex)
  nextIndex = currentIndex + 1
  if nextIndex > #table then
    nextIndex = 1
  end

  return nextIndex
end

-- Misc

function flatten(t)
  local ret = {}
  for _, v in ipairs(t) do
    if type(v) == 'table' then
      for _, fv in ipairs(flatten(v)) do
        ret[#ret + 1] = fv
      end
    else
      ret[#ret + 1] = v
    end
  end
  return ret
end

function isFunction(a)
  return type(a) == "function"
end

function maybe(func)
  return function (argument)
    if argument then
      return func(argument)
    else
      return nil
    end
  end
end

-- Flips the order of parameters passed to a function
function flip(func)
  return function(...)
    return func(table.unpack(reverse({...})))
  end
end

-- gets propery or method value
-- on a table
function result(obj, property)
  if not obj then return nil end

  if isFunction(property) then
    return property(obj)
  elseif isFunction(obj[property]) then -- string
    return obj[property](obj) -- <- this will be the source of bugs
  else
    return obj[property]
  end
end


invoke = result -- to indicate that we're calling a method

-- property, object
function getProperty(property)
    return partial(flip(result), property)
end


-- from Moses
--- Reverses values in a given array. The passed-in array should not be sparse.
-- @name reverse
-- @tparam table array an array
-- @treturn table a copy of the given array, reversed
function reverse(array)
  local _array = {}
  for i = #array,1,-1 do
    _array[#_array+1] = array[i]
  end
  return _array
end

function compose(...)
  local functions = {...}

  return function (...)
    local result

    for i, func in ipairs(functions) do
      if i == 1 then
        result = func(...)
      else
        result = func(result)
      end
    end

    return result
  end
end

-- http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- does a shallow comparison of
-- key based tables

-- a = {h = 50, w = 50}
-- b = {h = 50, w = 50}
-- c = {h = 100, w = 100}

-- compareShallow(a, b)
-- > true

-- compareShallow(a, c)
-- > false

-- @param tableA table
-- @param tableB table

-- @returns bool
function compareShallow(tableA, tableB)
  if tableA == nil or tableB == nil then return false end

  for k, v in pairs(tableA) do
    -- dbgf('comparing %s to %s', v, tableB[k])
    if v ~= tableB[k] then return false end
  end

  return true
end

function keys(T)
  local keys = {}

  for k, _ in pairs(T) do
    table.insert(keys, k)
  end

  return keys
end

function uniq(T)
  local hash    = {}
  local results = {}

  hs.fnutils.each(T, function(value)
    if not hash[value] then
      table.insert(results, value)
      hash[value] = true
    end
  end)

  return results
end
