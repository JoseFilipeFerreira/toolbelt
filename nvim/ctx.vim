autocmd Filetype markdown call SetWritingOpts()
autocmd Filetype tex call SetWritingOpts()
function SetWritingOpts()
    set linebreak
    set textwidth=80
endfunction

autocmd FileType tex call SetTexOpts()
function SetTexOpts()
    map <leader>r :silent !pdflatex --shell-escape %:p <Return>
    command! Re !pdflatex --shell-escape %:p
endfunction

"lp_solve
autocmd BufEnter *.lp map <leader>r :!lp_solve %:p <Return>
autocmd BufEnter *.lp set syntax=perl
