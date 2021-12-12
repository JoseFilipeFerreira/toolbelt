local iabbrev = require('utils.misc').iabbrev
local au = require('utils.au')
local command = require('utils.command')

local set = vim.opt
local expand = vim.fn.expand
local fn = vim.fn

au.group('writing-opts', function(g)
    g.Filetype = {
        {'markdown', 'tex'},
        function()
            set.linebreak = true
            set.textwidth = 80

            inoremap(',C', 'Ç')
            inoremap(',c', 'ç')
            inoremap(']A', 'Á')
            inoremap(']E', 'É')
            inoremap(']I', 'Í')
            inoremap(']O', 'Ó')
            inoremap(']U', 'Ú')
            inoremap(']a', 'á')
            inoremap(']e', 'é')
            inoremap(']i', 'í')
            inoremap(']o', 'ó')
            inoremap(']u', 'ú')
            inoremap('^A', 'Â')
            inoremap('^E', 'Ê')
            inoremap('^I', 'Î')
            inoremap('^O', 'Ô')
            inoremap('^U', 'Û')
            inoremap('^a', 'â')
            inoremap('^e', 'ê')
            inoremap('^i', 'î')
            inoremap('^o', 'ô')
            inoremap('^u', 'û')
            inoremap('}A', 'À')
            inoremap('}E', 'È')
            inoremap('}I', 'Ì')
            inoremap('}O', 'Ò')
            inoremap('}U', 'Ù')
            inoremap('}a', 'à')
            inoremap('}e', 'è')
            inoremap('}i', 'ì')
            inoremap('}o', 'ò')
            inoremap('}u', 'ù')
            inoremap('~A', 'Ã')
            inoremap('~N', 'Ñ')
            inoremap('~O', 'Õ')
            inoremap('~a', 'ã')
            inoremap('~n', 'ñ')
            inoremap('~o', 'õ')

            mapx.group({ silent = true, buffer = true }, function()
                nnoremap('k', 'gk')
                nnoremap('j', 'gj')
                nnoremap('0', 'g0')
                nnoremap('$', 'g$')
            end)
        end
    }
    g.Filetype = {
        'tex',
        function()
            nnoremap('<leader>r', function()
                local file = expand('%:p')
                vim.cmd('silent !pdflatex --shell-escape ' .. file .. '> /dev/null &')
            end)
            command.Re = function()
                vim.cmd('!pdflatex --shell-escape ' .. expand('%:p'))
            end

            inoremap(',tt', [[\texttt{}<Space><++><Esc>T{i]])
            inoremap(',ve', [[\verb!!<Space><++><Esc>T!i]])
            inoremap(',bf', [[\textbf{}<Space><++><Esc>T{i]])
            inoremap(',it', [[\textit{}<Space><++><Esc>T{i]])
            inoremap(',ch', [[\chapter{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',st', [[\section{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',sst', [[\subsection{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',ssst', [[\subsubsection{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',bit', [[\begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>]])
            inoremap(',benum', [[\begin{enumerate}<CR><CR>\end{enumerate}<Return><++><Esc>kki<Tab>\item<Space>]])
            inoremap(',bfi', [[\begin{figure}[h]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics[width=\textwidth]{}<CR>\caption{<++>}<CR>\label{fig:<++>}<Esc>kk$i]])
            inoremap(',beg', [[\begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l]])
        end
    }
end)

nnoremap('<leader>l', ':setlocal spell! spelllang=pt_pt<CR>')
nnoremap('<leader>L', ':setlocal spell! spelllang=en_gb<CR>')
nnoremap('<A-l>', 'z=')
