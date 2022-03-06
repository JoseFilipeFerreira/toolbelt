-- luacheck: globals map mapx nmap imap inoremap vnoremap nnoremap
local command = require('utils.command')

-- copy paste in vim
inoremap('<C-v>', '<ESC>"+pa')
vnoremap('<C-c>', '"+y')
vnoremap('<C-x>', '"+d')

-- no help
nmap('<F1>', ':echo<CR>')
imap('<F1>', '<C-o>:echo<CR>')

-- Ctrl+S to save
map('<C-S>', ':w<CR>')
imap('<C-S>', '<Esc>:w<CR>a')

-- clear search register
nmap('<leader><leader>', ':noh<CR>')

-- Fast replace
nnoremap('s', ':s//g<Left><Left>')
nnoremap('S', ':%s//g<Left><Left>')
vnoremap('s', ':s//g<Left><Left>')

-- nerdtree
nnoremap('<F2>', ':NERDTreeToggle<CR>')
inoremap('<F2>', ':NERDTreeToggle<CR>')

-- telescope
mapx.group({ silent = true }, function()
    nnoremap('<leader>p', function() require('telescope.builtin').find_files() end)
    nnoremap('<leader>b', function() require('telescope.builtin').buffers() end)
    nnoremap('<leader>f', function() require('telescope.builtin').live_grep() end)
    command.Rg = function() require('telescope.builtin').grep_string() end
end)
