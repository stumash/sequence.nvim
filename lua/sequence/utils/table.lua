local M = {}

function M.pack(...)
  return { ... }
end

function M.unpack(t)
  return unpack(t)
end

function M.is_empty(t)
  local first_value = next(t, nil)
  return first_value == nil
end

-- @returns true if t1 deep equals t2
function M.equals(t1, t2)
  local tp = type(t1)
  if tp ~= type(t2) then return false end
  if tp ~= 'table' then return t1 == t2 end

  for _,tables in ipairs({{t1, t2}, {t2, t1}}) do
    local tb1, tb2 = tables[1], tables[2]
    for k,v1 in pairs(tb1) do
      tp = type(v1)
      local v2 = tb2[k]
      if tp ~= type(v2) then return false end
      if tp ~= 'table' and v1 ~= v2 then return false end
      if tp == 'table' and not M.equals(v1, v2) then return false end
    end
  end

  return true
end

return M
