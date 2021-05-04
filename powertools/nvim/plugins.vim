" Install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Auto-Install missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync
  \|   PlugClean
  \|   PlugUpdate --sync
  \|   PlugUpgrade
  \|   q | source $MYVIMRC
  \| endif

" Plugins
call plug#begin()

" Theme
Plug 'morhetz/gruvbox'

" File Browsing
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'

" Syntax highlighting
Plug 'machakann/vim-highlightedyank'
Plug 'sheerun/vim-polyglot'

"Formating and Errors
Plug 'tpope/vim-commentary'
Plug 'sbdchd/neoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'

call plug#end()

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
highlight Normal ctermbg=None

" FZF config
nmap <leader>p :FZF<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

"" Make fzf match the vim colorscheme colors
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Neoformat config
map <leader>f :Neoformat<CR>
let g:rustfmt_opt="--edition 2018"
let g:shfmt_opt="-ci"

" Nerdtree config
map <F2> :NERDTreeToggle<CR>
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1

" Highlight yank
let g:highlightedyank_highlight_duration = 100

" COC
"" Tab completion and navigation
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

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
