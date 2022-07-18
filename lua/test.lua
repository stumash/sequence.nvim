local M = {}

local function printTable(t)
  if t == nil then
    print'nil'
    return
  end
  print('{')
  for k,v in pairs(t) do
    print('  ' .. tostring(k) .. ':' .. tostring(v) .. ',')
  end
  print('}')
end

local function spaces(n)
  local result = ''
  while n > 0 do
    result, n = result .. ' ', n -1
  end
  return result
end

-- Here is an example of a test 'results'
--
-- {
--   title = "some module or type",
--   wins = {
--     {
--       should = "should have some behavior",
--       asserts = {
--         -- all 'asserts' in 'wins' have 'pass'=true
--         { check = "meet some condition", pass = true },
--         { check = "meet some condition", pass = true },
--         ...
--       }
--     }
--   },
--   losses = {
--     {
--       should = "should have some behavior",
--       asserts = {
--         -- at least one 'assert' in 'losses' must have 'pass'=false
--         { check = "meet some condition", pass = true },
--         { check = "meet some condition", pass = false },
--         ...
--       }
--     }
--   },
--   kids = {
--     {
--       title = "some sub module or type",
--       ... -- wins, losses, kids
--     },
--     ...
--   },
-- }

local function print_results(results, indent)
  local spc_indent = spaces(indent)
  print(spc_indent .. results['title'])

end

function M.describe(title, f, parent)
  local results = { title = title, wins = {}, losses = {}, kids = {} }

  local function it(should, f)
    local result = { should = should, asserts = {} }
    local all_pass = true

    local function assert(check, b)
      table.insert(result.asserts, { check = check, pass = b })

      if not b then
        all_pass = false
      end
    end

    f(assert)

    if all_pass then
      table.insert(results.wins, result)
    else
      table.insert(results.losses, result)
    end
  end

  local function describe_w_parent(title, f)
    M.describe(title, f, results)
  end

  f(it, describe_w_parent)
  if parent == nil then
    print_results(results, 0)
  else
    table.insert(parent.kids, results)
  end
end

local function zip(iter1, iter2)
  return function()
    local next1, next2 = iter1(), iter2()
    if next1 ~= nil and next2 ~= nil then
      return next1, next2
    else return nil end
  end
end

return M
