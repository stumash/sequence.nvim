local utils = require('sequence.utils')
local seqs = require('sequence.seqs')

local M = {}




 ParseResult = {}






function ParseResult.new(first, last, sep, skip)
   local self
   self.first = first
   self.last = last
   self.sep = sep
   self.skip = skip
   setmetatable(self, ParseResult)
   return self
end

function M.parse(s)
   local args = utils.split(s)
   if #args < 2 then
      return "not enough arguments"
   end

   local range, sep, skip = { args[1], args[2] }, args[3], args[4]
   local first, last = range[1], range[2]
   if utils.all(range, utils.is_integer) then
      local first_i, last_i = utils.to_integer(first), utils.to_integer(last)
      local skip_i = 1
      local result = ParseResult.new(first_i, last_i, sep, skip_i)
      return nil
   elseif utils.all(range, utils.is_float) then
   else
      return "first and last must both be integers or floats"
   end
end

return M
