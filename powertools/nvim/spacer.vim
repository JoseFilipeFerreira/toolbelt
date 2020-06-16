autocmd FileType tex      map <leader>r :silent !pdflatex --shell-escape %:p <Return>
autocmd FileType lp       map <leader>r :!lp_solve %:p <Return>
autocmd FileType pdf      map <leader>r :!pdf %:p <Return> :q <Return>
autocmd FileType markdown map <leader>r :!markdown-reader %:p <Return>
autocmd FileType lex      map <leader>r :!flex %:p && gcc -o %:r lex.yy.c && ./%:r < *.txt <Return>
autocmd FileType sh       map <leader>r :!shellcheck --color=never -x %<Return>
