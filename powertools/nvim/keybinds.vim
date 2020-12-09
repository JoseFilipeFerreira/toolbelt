" copy paste in vim
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d

" I don't need help
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <M-h> <C-w>H
nnoremap <M-j> <C-w>J
nnoremap <M-k> <C-w>K
nnoremap <M-l> <C-w>L

" split resize
nnoremap <M-K> <C-w>+
nnoremap <M-J> <C-w>-
nnoremap <M-H> <C-w><
nnoremap <M-L> <C-w>>

" spelling
map <leader>l :setlocal spell! spelllang=pt_pt<CR>
map <leader>L :setlocal spell! spelllang=en_gb<CR>
nnoremap <A-Enter> z=

" Ctrl+S to save
map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>a

" clear search register
nmap <leader><leader> :noh<CR>

" Fix Y
nnoremap Y y$

" Fast replace
nnoremap s :s//g<Left><Left>
nnoremap S :%s//g<Left><Left>
vnoremap s :s//g<Left><Left>
