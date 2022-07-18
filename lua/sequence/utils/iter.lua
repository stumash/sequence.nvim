local tu = require'sequence.utils.table'

local M = {}

function M.range(first, last, skip)
  skip = skip or 1
  local i = first
  return function()
    if i > last then return nil end
    local retval = i
    i = i + 1
    return retval
  end
end

function M.arr_iter(arr)
  local i = 1
  return function()
    if i > #arr then return nil end
    local retval = arr[i]
    i = i + 1
    return retval
  end
end

function M.arr_iter_rev(arr)
  local i = #arr
  return function()
    if i < 1 then return nil end
    local retval = arr[i]
    i = i - 1
    return retval
  end
end

function M.str_iter(s)
  local i = 1
  return function()
    if i > #s then return nil end
    local retval = string.sub(s, i, i)
    i = i + 1
    return retval
  end
end

function M.str_iter_rev(s)
  local i = #s
  return function()
    if i < 1 then return nil end
    local retval = string.sub(s, i, i)
    i = i - 1
    return retval
  end
end

function M.str_split(s, c)
  c = c or " "
  local start = 1
  return function()
    if start > #s then return nil end
    local i = start

    while string.sub(s, i, i) == c do
      i = i + 1
    end
    if i > #s then return nil end

    local result = string.sub(s, i, i)
    i = i + 1

    while i <= #s and string.sub(s, i, i) ~= c do
      result = result .. string.sub(s, i, i)
      i = i + 1
    end

    while i <= #s and string.sub(s, i, i) == c do
      i = i + 1
    end

    start = i
    return result
  end
end

function M.map(iter, f)
  return function()
    local next = tu.pack(iter())
    if tu.is_empty(next) then return nil end
    return f(tu.unpack(next))
  end
end

function M.enumerate(iter)
  local i = 1
  return function()
    local next = tu.pack(iter())
    if tu.is_empty(next) then return nil end
    local ret_i = i
    i = i + 1
    return ret_i, tu.unpack(next)
  end
end

function M.rev_tuple(tup_iter)
  return function()
    local tup = tu.pack(tup_iter())
    if tu.is_empty(tup) then return nil end
    return tu.unpack(M.to_array(M.arr_iter_rev(tup)))
  end
end

function M.zip(iter1, iter2)
  return function()
    local next1, next2 = iter1(), iter2()
    if next1 == nil or next2 == nil then return nil end
    return next1, next2
  end
end

function M.all(iter, f)
  for v in iter do
    if not f(iter()) then return false end
  end
  return true
end

-- @param iter: iterator - the iterator whose values will populate the set
-- @returns a table where all the values are `true`
function M.to_set(iter)
  local result = {}
  for v in iter do
    result[v] = true
  end
  return result
end

-- @param iter: iterator - the iterator whose values will populate the array
-- @returns an array {integer:any}
function M.to_array(iter)
  local result = {}
  for v in iter do
    table.insert(result, v)
  end
  return result
end

-- @param tup_iter: iterator - the iterator whose tuple values will populate the array
-- @returns a table containing every tuple a,b from tup_iter as table[a]=b
function M.to_table(tup_iter)
  local result = {}
  for k,v in tup_iter do
    result[k] = v
  end
  return result
end

return M
