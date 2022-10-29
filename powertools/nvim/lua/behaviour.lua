-- luacheck: globals vim
local set = vim.opt
local au = require('utils.au')
local command = require('utils.command')

set.mouse=nil

-- tabs
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftwidth = 4
set.smarttab = true

-- scroll
set.scrolloff=4

-- opening files
set.hidden = true
set.splitbelow = true
set.splitright = true

-- make path recursive
set.path='**'

-- show line number
set.number = true

-- case insensitive search
set.ignorecase = true
set.smartcase = true

-- clear trailing whitespaces
au.group('bad-ws', function(g) g.BufWritePre = { '*', '%s/\\s\\+$//e' } end)

-- undo file
set.undodir = vim.fn.stdpath('cache')..'/vimundo'
set.undofile = true

au.group('read-extra-file-types', function(g)
    g.BufReadPre = {
        '*.pdf',
        function()
            vim.cmd [[execute '!exec zathura "%" &' | :q!]]
        end
    }
end)

command.W = 'w'
command.Q ='q'
command.WQ = 'wq'
command.Wq = 'wq'
