-- luacheck: globals nnoremap inoremap

local mapx = require('mapx')

-- split navigations
mapx.nnoremap('<C-J>', '<C-W><C-J>')
mapx.nnoremap('<C-K>', '<C-W><C-K>')
mapx.nnoremap('<C-L>', '<C-W><C-L>')
mapx.nnoremap('<C-H>', '<C-W><C-H>')

mapx.nnoremap('<M-h>', '<C-w>H')
mapx.nnoremap('<M-j>', '<C-w>J')
mapx.nnoremap('<M-k>', '<C-w>K')
mapx.nnoremap('<M-l>', '<C-w>L')

-- split resize
mapx.nnoremap('<M-K>', '<C-w>+')
mapx.nnoremap('<M-J>', '<C-w>-')
mapx.nnoremap('<M-H>', '<C-w><')
mapx.nnoremap('<M-L>', '<C-w>>')

-- Fix Y
mapx.nnoremap('Y', 'y$')

-- alt tab
mapx.nnoremap('<leader><Tab>', '<C-^>')

-- jump to marker
mapx.inoremap(',,', '<Esc>/<++><Enter>"_c4l')

-- easier start and end
mapx.nnoremap('H', '^')
mapx.nnoremap('L', '$')
