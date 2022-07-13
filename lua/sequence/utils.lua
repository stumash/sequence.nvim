local M = {}

function M.range_iter(
   first,
   last,
   skip)

   skip = skip or 1
   local i = first
   return function()
      if i <= last then
         local result = i
         i = i + 1
         return result
      else
         return nil
      end
   end
end

function M.set(iter)
   local result = {}
   for t in iter do
      result[t] = true
   end
   return result
end


function M.map(iter, f)
   return function()
      local value = iter()
      if value == nil then return nil end
      return f(value)
   end
end

function M.iter_to_array(iter)
   local i, result = 1, {}
   for t in iter do
      result[i] = t
      i = i + 1
   end
   return result
end

function M.enumerate(iter)
   local i = 1
   return function()
      local next = iter()
      if type(next) == "nil" then return nil
      else
         local result = { i, next }
         i = i + 1
         return result
      end
   end
end

function M.rev_tuple(iter)
   return function()
      local next = iter()
      if type(next) == "nil" then return nil else
         local v, k = next[1], next[2]
         return { k, v }
      end
   end
end

function M.array(iter)
   local result = {}
   for tup in iter do
      local i, t = tup[1], tup[2]
      result[i] = t
   end
   return result
end

function M.table(iter)
   local result = {}
   for tup in iter do
      local k, v = tup[1], tup[2]
      result[k] = v
   end
   return result
end

local function integer_to_string(i) return tostring(i) end
local digit_char_set = M.set(M.map(M.range_iter(0, 9), integer_to_string))
local function is_digit(s) return digit_char_set[s] or false end
local char_to_digit = M.table(M.rev_tuple(M.enumerate(M.map(M.range_iter(0, 9), integer_to_string))))


function M.str_iter(s)
   local i = 0

   return function()
      if i > #s then
         return nil
      end

      local result = s:sub(i, i)
      i = i + 1
      return result
   end
end

function M.str_iter_rev(s)
   local i = #s

   return function()
      if i <= 0 then
         return nil
      end

      local result = s:sub(i, i)
      i = i - 1
      return result
   end
end

function M.is_integer(s)
   for c in M.str_iter(s) do
      if not is_digit(c) then
         return false
      end
   end
   return true
end

function M.to_integer(s)
   local result = 0
   local col = 1
   for c in M.str_iter_rev(s) do
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
   for c in M.str_iter(s) do
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

function M.split(s)
   local start, i_result, result = 1, 1, {}
   for i in M.range_iter(1, #s) do
      if s:sub(i, i) == ' ' then
         if start < i then
            result[i_result] = s:sub(start, i - 1)
            start = i + 1
            i_result = i_result + 1
         else
            start = start + 1
         end
      end
   end
   if start < #s then
      result[i_result] = s:sub(start, #s)
   end
   return result
end

function M.array_iter(arr)
   local i = 1
   return function()
      if i <= #arr then
         local result = arr[i]
         i = i + 1
         return result
      else
         return nil
      end
   end
end

function M.all(arr, f)
   for t in M.array_iter(arr) do
      if not f(t) then
         return false
      end
   end
   return true
end

return M
