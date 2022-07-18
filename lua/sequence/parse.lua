local u = require'sequence.utils'
local iu = require'sequence.utils.iter'
local seqs = require'sequence.seqs'

local M = {}

-- @param s: string - the input string
-- @returns string - the input string with the following replacements:
--   \s -> space
--   \t -> tab
--   \n -> newline
local function parse_sep(s)
   if sep == nil then return ' ' end

   local result = ''
   local escape_mode = false
   for c in iu.str_iter(s) do
      if c == [[\]] then
         escape_mode = true
      elseif escape_mode then
         escape_mode = false
         if c == 's' then
            result = result .. ' '
         elseif c == 't' then
            result = result .. '\t'
         elseif c == 'n' then
            result = result .. '\n'
         else
            result = result .. c
         end
      else
         result = result .. c
      end
   end
   return result
end

function M.parse(s)
   local args = u.split(s)
   if #args < 2 then
      return "not enough arguments"
   end

   local range, sep, skip = { args[1], args[2] }, parse_sep(args[3]), args[4]
   local first, last = range[1], range[2]

   local result = nil
   if iu.all(iu.arr_iter(range), u.is_integer) then
      local first_i, last_i = u.to_integer(first), u.to_integer(last)
      skip = skip or 1
      return 'i', { first=first, last=last, sep=sep, skip=skip }
   elseif u.all(iu.arr_iter(range), u.is_float) then
      local first_f, last_f = u.to_float(first), u.to_float(last)
      skip = skip or 1.0
      return 'f', { first=first, last=last, sep=sep, skip=skip }
   else
      return nil, "first and last must both be integers or floats"
   end
end

return M
