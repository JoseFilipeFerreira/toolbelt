autocmd Filetype markdown call SetWritingOpts()
autocmd Filetype tex call SetWritingOpts()
function SetWritingOpts()
    set linebreak
    set textwidth=80
    inoremap `A À
    inoremap 'A Á
    inoremap `E É
    inoremap `a à
    inoremap 'a á
    inoremap `e é
    inoremap `o ó
    inoremap `u ú
endfunction

autocmd FileType tex call SetTexOpts()
function SetTexOpts()
    command! Re !pdflatex --shell-escape %:p

    inoremap ,tt \texttt{}<Space><++><Esc>T{i
    inoremap ,ve \verb!!<Space><++><Esc>T!i
    inoremap ,bf \textbf{}<Space><++><Esc>T{i
    inoremap ,it \textit{}<Space><++><Esc>T{i
    inoremap ,ch \chapter{}<Return><Return><++><Esc>2kt}a
    inoremap ,se \section{}<Return><Return><++><Esc>2kt}a
    inoremap ,sse \subsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,ssse \subsubsection{}<Return><Return><++><Esc>2kt}a
    inoremap ,bit \begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>
    inoremap ,benum \begin{enumerate}<CR><CR>\end{enumerate}<Return><++><Esc>kki<Tab>\item<Space>
    inoremap ,bfi \begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics[width=\textwidth]{}<CR>\caption{<++>}<Esc>k$i
    inoremap ,beg \begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l

    " Jumps
    inoremap ,, <Esc>/<++><Enter>"_c4l

endfunction

