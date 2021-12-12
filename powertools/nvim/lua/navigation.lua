-- split navigations
nnoremap('<C-J>', '<C-W><C-J>')
nnoremap('<C-K>', '<C-W><C-K>')
nnoremap('<C-L>', '<C-W><C-L>')
nnoremap('<C-H>', '<C-W><C-H>')

nnoremap('<M-h>', '<C-w>H')
nnoremap('<M-j>', '<C-w>J')
nnoremap('<M-k>', '<C-w>K')
nnoremap('<M-l>', '<C-w>L')

-- split resize
nnoremap('<M-K>', '<C-w>+')
nnoremap('<M-J>', '<C-w>-')
nnoremap('<M-H>', '<C-w><')
nnoremap('<M-L>', '<C-w>>')

-- Fix Y
nnoremap('Y', 'y$')

-- alt tab
nnoremap('<leader><Tab>', '<C-^>')

-- jump to marker
inoremap(',,', '<Esq>/<++><Enter>"_c4l')

-- easier start and end
nnoremap('H', '^')
nnoremap('L', '$')
