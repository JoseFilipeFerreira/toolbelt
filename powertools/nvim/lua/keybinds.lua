-- luacheck: globals map mapx nmap imap inoremap vnoremap nnoremap
local command = require('utils.command')

local mapx = require('mapx')

-- copy paste in vim
mapx.inoremap('<C-v>', '<ESC>"+pa')
mapx.vnoremap('<C-c>', '"+y')
mapx.vnoremap('<C-x>', '"+d')

-- no help
mapx.nmap('<F1>', ':echo<CR>')
mapx.imap('<F1>', '<C-o>:echo<CR>')

-- Ctrl+S to save
mapx.map('<C-S>', ':w<CR>')
mapx.imap('<C-S>', '<Esc>:w<CR>a')

-- clear search register
mapx.nmap('<leader><leader>', ':noh<CR>')

-- Fast replace
mapx.nnoremap('s', ':s//g<Left><Left>')
mapx.nnoremap('S', ':%s//g<Left><Left>')
mapx.vnoremap('s', ':s//g<Left><Left>')

-- nerdtree
mapx.nnoremap('<F2>', ':NERDTreeToggle<CR>')
mapx.inoremap('<F2>', ':NERDTreeToggle<CR>')

-- telescope
mapx.group({ silent = true }, function()
    mapx.nnoremap('<leader>p', function() require('telescope.builtin').find_files() end)
    mapx.nnoremap('<leader>b', function() require('telescope.builtin').buffers() end)
    mapx.nnoremap('<leader>s', function() require('telescope.builtin').live_grep() end)
    command.Rg = function() require('telescope.builtin').grep_string() end
end)
