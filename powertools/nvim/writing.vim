autocmd Filetype markdown call SetWritingOpts()
autocmd Filetype text call SetWritingOpts()
autocmd Filetype tex call SetWritingOpts()
autocmd FileType tex call SetTexOpts()

function SetWritingOpts()
    set linebreak
    set textwidth=80

    inoremap ,C Ç
    inoremap ,c ç
    inoremap ]A Á
    inoremap ]E É
    inoremap ]I Í
    inoremap ]O Ó
    inoremap ]a á
    inoremap ]e é
    inoremap ]i í
    inoremap ]o ó
    inoremap }A À
    inoremap }E È
    inoremap }I Ì
    inoremap }O Ò
    inoremap }a à
    inoremap }e è
    inoremap }i ì
    inoremap }o ò
    inoremap ~A Ã
    inoremap ~O Õ
    inoremap ~a ã
    inoremap ~o õ

    iabbrev  tambem também

endfunction

function SetTexOpts()
    command! Re !pdflatex --shell-escape %:p
    map <leader>r :silent !pdflatex --shell-escape %:p<CR>

    inoremap ,tt \texttt{}<Space><++><Esc>T{i
    inoremap ,ve \verb!!<Space><++><Esc>T!i
    inoremap ,bf \textbf{}<Space><++><Esc>T{i
    inoremap ,it \textit{}<Space><++><Esc>T{i
    inoremap ,ch \chapter{}<Return><Return><++><Esc>2kt}a
    inoremap ,st \section{}<Return><Return><++><Esc>2kt}a
    inoremap ,sst \subsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,ssst \subsubsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,bit \begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>
    inoremap ,benum \begin{enumerate}<CR><CR>\end{enumerate}<Return><++><Esc>kki<Tab>\item<Space>
    inoremap ,bfi \begin{figure}[h]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics[width=\textwidth]{}<CR>\caption{<++>}<CR>\label{fig:<++>}<Esc>kk$i
    inoremap ,beg \begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l

    " Jumps
    inoremap ,, <Esc>/<++><Enter>"_c4l

endfunction

" spelling
map <leader>l :setlocal spell! spelllang=pt_pt<CR>
map <leader>L :setlocal spell! spelllang=en_gb<CR>
map <leader><F10> [s
map <leader><F12> ]s
nnoremap <A-Enter> z=
