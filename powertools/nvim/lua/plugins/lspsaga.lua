-- luacheck: globals mapx nnoremap inoremap vnoremap
local saga = require('lspsaga')
local mapx = require('mapx')

saga.init_lsp_saga {
    error_sign = '>>',
    warn_sign = '?',
    hint_sign = '>',
    infor_sign = '>',
    border_style = "round",
    code_action_icon = "*",
}

mapx.group({ silent = true }, function()
    mapx.nnoremap('K', require('lspsaga.hover').render_hover_doc)
    mapx.inoremap('<C-j>', require('lspsaga.signaturehelp').signature_help)
    mapx.nnoremap('gh', require('lspsaga.provider').lsp_finder)
    mapx.nnoremap('<leader>c', require('lspsaga.rename').rename)
    local diag = require('lspsaga.diagnostic')
    mapx.nnoremap('<F10>', function() diag.navigate('prev')() end)
    mapx.nnoremap('<F12>', function() diag.navigate('next')() end)
    local codeaction = require('lspsaga.codeaction')
    mapx.nnoremap('<A-Return>', codeaction.code_action)
    mapx.vnoremap('<A-Return>', codeaction.range_code_action)
end)
