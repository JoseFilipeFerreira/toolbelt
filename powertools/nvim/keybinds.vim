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

" toggle spelling
map <leader>l :setlocal spell! spelllang=en_gb,pt_pt<CR>
map <leader>L :setlocal spell! spelllang=en_gb<CR>
" Open spelling suggestions
nnoremap <A-Enter> z=

" Ctrl+S to save
map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>a

" Alt-Tab
map <leader><Tab> :e #<CR>

" clear search register
nmap <leader><leader> :noh<CR>

