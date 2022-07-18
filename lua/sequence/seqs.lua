local M = {}

function M.seqInt(first, last, sep, skip)
   local result = ""

   local curr, i0 = first, true
   while curr <= last do
      if i0 then
         i0 = false
      else
         result = result .. sep
      end

      result = result .. tostring(curr)
      curr = curr + skip
   end

   return result
end


function M.seqFloat(first, last, sep, skip)
   local result = ""

   local curr, i0 = first, true
   while curr <= last do
      if i0 then
         i0 = false
      else
         result = result .. sep
      end

      result = result .. tostring(curr)
      curr = curr + skip
   end

   return result
end

return M
