runtime! archlinux.vim

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'PotatoesMaster/i3-vim-syntax'

Plug 'scrooloose/nerdtree'

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'tpope/vim-commentary'

Plug 'junegunn/goyo.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Let me sudo save in nvim
Plug 'lambdalisue/suda.vim'

call plug#end()

""" PLUGIN CONFIGS

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
highlight Normal ctermbg=None

" Nerdtree config
map <F2> :NERDTreeToggle<CR>
let NERDTreeDirArrows = 1

augroup nerdtreeconcealbrackets
      autocmd!
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
      autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
      autocmd FileType nerdtree setlocal conceallevel=2
      autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "! ",
    \ "Staged"    : "+ ",
    \ "Untracked" : "? ",
    \ "Renamed"   : "> ",
    \ "Unmerged"  : "# ",
    \ "Deleted"   : "- ",
    \ "Dirty"     : "? ",
    \ "Clean"     : "",
    \ "Ignored"   : "",
    \ "Unknown"   : ""
    \ }

let NERDTreeQuitOnOpen = 1

" Coc
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> <F10> <Plug>(coc-diagnostic-prev)
nmap <silent> <F12> <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" LaTeX
autocmd BufEnter *.tex set linebreak
autocmd FileType tex map <Space>r :silent !pdflatex --shell-escape %:p <enter>
autocmd BufEnter *.tex command! Re !pdflatex --shell-escape %:p
autocmd BufEnter *.tex set textwidth=80

"lp_solve
autocmd BufEnter *.lp map <Space>r :!lp_solve %:p <enter>
autocmd BufEnter *.lp set syntax=perl

""" SETTINGS
" indent using spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" splitbelow and right
set splitright splitbelow

" show line number
set number

" copy paste in vim
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d 

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <M-h> <C-w>H
nnoremap <M-j> <C-w>J
nnoremap <M-k> <C-w>K
nnoremap <M-l> <C-w>L

" Ctrl+S to save
map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>a

" Alt-Tab
map <Space><Tab> :e #<CR>

" Scroll with mouse
set mouse=a

" clear search register
nmap <space><space> :noh<CR>

"spelling
set spell! spelllang=en_gb,pt_pt
" Open spelling suggestions
nnoremap <A-Enter> z=

""" COMMANDS
command! W w
command! Q q
command! WQ wq

" make path recursive
set path=**

set undodir=~/.cache/vimundo
set undofile

set scrolloff=4
