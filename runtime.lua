-- runtime.lua

local runtime = {}

function runtime.io_write(...)
  io.write(...)
end

function runtime.input(prompt)
  io.write(prompt)
  return io.read()
end

function runtime.random()
  return math.random()
end

function runtime.floor(number)
  return math.floor(number)
end

function runtime.ceil(number)
  return math.ceil(number)
end

function runtime.range(start, stop, step)
  if not stop then
    stop = start
    start = 0
  end
  step = step or 1

  local t = {}
  for i = start, stop - 1, step do
    table.insert(t, i)
  end
  return t
end

function runtime.len(value)
  if type(value) == "table" then
    return #value
  elseif type(value) == "string" then
    return string.len(value)
  else
    error("Unsupported type for len(): " .. type(value))
  end
end

function runtime.concat(...)
  local args = {...}
  local result = ""
  for _, value in ipairs(args) do
    result = result .. tostring(value)
  end
  return result
end

function runtime.type(value)
  return type(value)
end

function runtime.tostring(value)
  return tostring(value)
end

function runtime.tonumber(value)
  return tonumber(value)
end

-- Add more utility functions as needed

return runtime
