-- luacheck: globals vim
local set = vim.opt
local au = require('utils.au')

set.termguicolors = true

-- THE RULER OF DISCIPLINE
set.colorcolumn = '101'
au.group('even-more-discipline', function(g)
    g.BufEnter = {
        {'*.c', '*.h', '*.cpp', '*.hpp'},
        function() set.colorcolumn = '81' end
    }
    g.BufLeave = {
        '*',
        function() set.colorcolumn = '101' end
    }
end)
