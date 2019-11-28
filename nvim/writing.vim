autocmd Filetype markdown call SetWritingOpts()
autocmd Filetype tex call SetWritingOpts()
function SetWritingOpts()
    set linebreak
    set textwidth=80
endfunction

autocmd FileType tex call SetTexOpts()
function SetTexOpts()
    command! Re !pdflatex --shell-escape %:p
endfunction

