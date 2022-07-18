local test = require'test'
local utils = require'sequence.utils'

local function printTable(t)
  local result = '{'
  for k,v in pairs(t) do
    result = result .. tostring(k) .. ':' .. tostring(v) .. ','
  end
  print(result .. '}')
end

test.describe('iter to array', function(it)
  it('should make the right array from basic iterators', function(assert)
    local range = utils.iter_to_array(utils.range_iter(1, 11, 2))
    print(range == {1, 3, 5, 7, 9, 11})
    assert('range is right', range == {1, 3, 5, 7, 9, 11})
  end)
end)
