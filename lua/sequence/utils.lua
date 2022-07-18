local iter = "sequence.utils.iter"
local tu = "sequence.utils.table"

local M = {}

function M.tup_get(tup_iter, i)
  return function()
    local next = tup_iter()
  end
end

local function integer_to_string(i)
  return tostring(i)
end

local digit_char_set = iter.set(iter.map(iter.range(0, 9), integer_to_string))
local function is_digit(s)
  return digit_char_set[s] or false
end

local char_to_digit = iter.table(iter.map(iter.range(0, 9), function(x)
  return x, integer_to_string(x)
end))

function M.is_integer(s)
  for c in iter.str_iter(s) do
    if not is_digit(c) then
      return false
    end
  end
  return true
end

-- @assume s contains only digits
function M.to_integer(s)
  local result = 0
  local col = 1
  for c in iter.str_iter_rev(s) do
    result = result + col * char_to_digit[c]
    col = col * 10
  end
  return result
end

function M.is_float(s)
  local found_point = false

  for c in M.str_iter(s) do
    if c == "." then
      if found_point then
        return false
      else
        found_point = true
      end
    elseif not is_digit(c) then
      return false
    end
  end

  return true
end

function M.count_decimal_digits(s)
  local count = 0
  local found_point = false
  for c in iter.str_iter(s) do
    if c == '.' then
      found_point = true
    else
      if found_point then
        count = count + 1
      end
    end
  end
  return count
end


function M.default_float_skip(first)
  local count = M.count_decimal_digits(first)
  if count <= 0 or count > 5 then return 1 end
  local result = 1.0
  while count > 0 do
    result = result / 10
    count = count - 1
  end
  return result
end

return M
