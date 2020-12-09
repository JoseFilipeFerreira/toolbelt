""" SETTINGS
" indent using spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" splitbelow and right
set splitright splitbelow

" show line number
set number

" set default shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" make path recursive
set path=**

set termguicolors
highlight Normal guibg=None

set scrolloff=4

set undodir=$XDG_CACHE_HOME/vimundo
set undofile

" mistakes
command! W w
command! Q q
command! WQ wq
command! Wq wq

""" AUTOCOMANDS
autocmd! BufNewFile,BufRead *.tool set syntax=sh
autocmd! BufNewFile,BufRead *.menu set syntax=sh
autocmd! BufEnter *xinitrc set syntax=sh
autocmd! BufNewFile,BufRead *.hbs set syntax=html

" clear trailling whitespace
autocmd! BufWritePre * %s/\s\+$//e

au BufReadPre *.pdf execute '!exec zathura "%" &' | :q!
