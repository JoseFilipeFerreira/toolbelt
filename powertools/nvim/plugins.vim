if empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
  silent !curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'PotatoesMaster/i3-vim-syntax'

Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-commentary'

Plug 'junegunn/goyo.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'sbdchd/neoformat'

" Syntax highlighting
Plug 'cespare/vim-toml'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'udalov/kotlin-vim'
Plug 'vim-python/python-syntax'
Plug 'baskerville/vim-sxhkdrc'
Plug 'plasticboy/vim-markdown'

call plug#end()

""" PLUGIN CONFIGS
" vim-markdown config
let g:vim_markdown_folding_disabled = 1

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
highlight Normal ctermbg=None

" Nerdtree config
map <F2> :NERDTreeToggle<CR>
let NERDTreeDirArrows = 1

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

" NeoFormat
map <leader>f :Neoformat<CR>
let g:shfmt_opt="-ci"
