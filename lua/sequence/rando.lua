local result, i = {}, 0
local on_confirm = function(s)
  result[i] = s
  i = i + 1
end

vim.ui.input("sequence> ", on_confirm)

vim.pretty_print(result)
