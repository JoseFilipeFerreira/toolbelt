local au = require('utils.au')
local command = require('utils.command')
local mapx = require'mapx'

-- luacheck: globals vim mapx inoremap nnoremap
local set = vim.opt
local expand = vim.fn.expand

au.group('writing-opts', function(g)
    g.Filetype = {
        {'markdown', 'plaintex', 'tex'},
        function()
            set.linebreak = true
            set.textwidth = 80

            mapx.inoremap(',C', 'Ç')
            mapx.inoremap(',c', 'ç')
            mapx.inoremap(']A', 'Á')
            mapx.inoremap(']E', 'É')
            mapx.inoremap(']I', 'Í')
            mapx.inoremap(']O', 'Ó')
            mapx.inoremap(']U', 'Ú')
            mapx.inoremap(']a', 'á')
            mapx.inoremap(']e', 'é')
            mapx.inoremap(']i', 'í')
            mapx.inoremap(']o', 'ó')
            mapx.inoremap(']u', 'ú')
            mapx.inoremap('^A', 'Â')
            mapx.inoremap('^E', 'Ê')
            mapx.inoremap('^I', 'Î')
            mapx.inoremap('^O', 'Ô')
            mapx.inoremap('^U', 'Û')
            mapx.inoremap('^a', 'â')
            mapx.inoremap('^e', 'ê')
            mapx.inoremap('^i', 'î')
            mapx.inoremap('^o', 'ô')
            mapx.inoremap('^u', 'û')
            mapx.inoremap('}A', 'À')
            mapx.inoremap('}E', 'È')
            mapx.inoremap('}I', 'Ì')
            mapx.inoremap('}O', 'Ò')
            mapx.inoremap('}U', 'Ù')
            mapx.inoremap('}a', 'à')
            mapx.inoremap('}e', 'è')
            mapx.inoremap('}i', 'ì')
            mapx.inoremap('}o', 'ò')
            mapx.inoremap('}u', 'ù')
            mapx.inoremap('~A', 'Ã')
            mapx.inoremap('~N', 'Ñ')
            mapx.inoremap('~O', 'Õ')
            mapx.inoremap('~a', 'ã')
            mapx.inoremap('~n', 'ñ')
            mapx.inoremap('~o', 'õ')
        end
    }
    g.Filetype = {
        {'tex', 'plaintex'},
        function()
            mapx.nnoremap('<leader>r', function()
                local file = expand('%:p')
                vim.cmd('silent !pdflatex --shell-escape ' .. file .. '> /dev/null &')
            end)
            command.Re = function()
                vim.cmd('!pdflatex --shell-escape ' .. expand('%:p'))
            end

            mapx.inoremap(',tt', [[\texttt{}<Space><++><Esc>T{i]])
            mapx.inoremap(',ve', [[\verb!!<Space><++><Esc>T!i]])
            mapx.inoremap(',bf', [[\textbf{}<Space><++><Esc>T{i]])
            mapx.inoremap(',it', [[\textit{}<Space><++><Esc>T{i]])
            mapx.inoremap(',ch', [[\chapter{}<Return><Return><++><Esc>2kt}a]])
            mapx.inoremap(',st', [[\section{}<Return><Return><++><Esc>2kt}a]])
            mapx.inoremap(',sst', [[\subsection{}<Return><Return><++><Esc>2kt}a]])
            mapx.inoremap(',ssst', [[\subsubsection{}<Return><Return><++><Esc>2kt}a]])
            mapx.inoremap(',bit', [[\begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>]])
            mapx.inoremap(',benum', [[\begin{enumerate}<CR><CR>\end{enumerate}<Return><++><Esc>kki<Tab>\item<Space>]])
            mapx.inoremap(',bfi',
[[\begin{figure}[h]

\end{figure}
<++><Esc>kki<Tab>\centering
<Tab>\includegraphics[width=\textwidth]{}
\caption{<++>}
\label{fig:<++>}<Esc>kk$i]])
            mapx.inoremap(',beg', [[\begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l]])
        end
    }
end)

mapx.nnoremap('<leader>l', ':setlocal spell! spelllang=pt_pt<CR>')
mapx.nnoremap('<leader>L', ':setlocal spell! spelllang=en_gb<CR>')
mapx.nnoremap('<A-l>', 'z=')
