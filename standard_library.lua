-- standard_library.lua

local stdlib = {}

-- String module
stdlib.string = {}

function stdlib.string.length(str)
  return #str
end

function stdlib.string.upper(str)
  return string.upper(str)
end

function stdlib.string.lower(str)
  return string.lower(str)
end

function stdlib.string.reverse(str)
  return string.reverse(str)
end

function stdlib.string.sub(str, start, finish)
  return string.sub(str, start, finish)
end

function stdlib.string.contains(str, pattern)
  return string.find(str, pattern) ~= nil
end

function stdlib.string.split(str, delimiter)
  local result = {}
  local pattern = "(.-)" .. delimiter .. "()"
  local pos = 1
  for part, delim in string.gmatch(str, pattern) do
    result[pos] = part
    pos = pos + 1
    if delim == "" then
      break
    end
  end
  return result
end

-- Math module
stdlib.math = {}

function stdlib.math.abs(num)
  return math.abs(num)
end

function stdlib.math.sqrt(num)
  return math.sqrt(num)
end

function stdlib.math.max(...)
  return math.max(...)
end

function stdlib.math.min(...)
  return math.min(...)
end

function stdlib.math.random(rangeStart, rangeEnd)
  if rangeStart and rangeEnd then
    return math.random(rangeStart, rangeEnd)
  elseif rangeStart then
    return math.random(rangeStart)
  else
    return math.random()
  end
end

function stdlib.math.floor(num)
  return math.floor(num)
end

function stdlib.math.ceil(num)
  return math.ceil(num)
end

-- Table module
stdlib.table = {}

function stdlib.table.length(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end
  return count
end

function stdlib.table.contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function stdlib.table.concat(...)
  local result = {}
  for _, tbl in ipairs({...}) do
    for _, value in ipairs(tbl) do
      table.insert(result, value)
    end
  end
  return result
end

function stdlib.table.merge(tbl1, tbl2)
  local result = {}
  for k, v in pairs(tbl1) do
    result[k] = v
  end
  for k, v in pairs(tbl2) do
    result[k] = v
  end
  return result
end

-- Add more modules and functions if I want, I guess... lol

return stdlib
