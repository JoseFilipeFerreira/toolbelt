autocmd BufEnter *.tex map <leader>r :silent !pdflatex --shell-escape %:p <Return>
autocmd BufEnter *.lp  map <leader>r :!lp_solve %:p <Return>
autocmd BufEnter *.pdf map <leader>r :!pdf %:p <Return> :q <Return>
