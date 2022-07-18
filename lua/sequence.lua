local p = require'sequence.parse'
local sq = reuire'sequence.seqs'

vim.ui.input('sq> ', function(s)
  local kind, params = p.parse(s)
  if kind == nil then
    local error_msg = params
    print(error_msg)
  else
  end
end)
