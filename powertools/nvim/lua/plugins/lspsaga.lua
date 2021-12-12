local saga = require('lspsaga')

saga.init_lsp_saga {
    error_sign = '>>',
    warn_sign = '?',
    hint_sign = '>',
    infor_sign = '>',
    border_style = "round",
    code_action_icon = "*",
}

mapx.group({ silent = true }, function()
    nnoremap('K', require('lspsaga.hover').render_hover_doc)
    inoremap('<C-j>', require('lspsaga.signaturehelp').signature_help)
    nnoremap('gh', require('lspsaga.provider').lsp_finder)
    nnoremap('<leader>c', require('lspsaga.rename').rename)
    local diag = require('lspsaga.diagnostic')
    nnoremap('<F10>', function() diag.lsp_jump_diagnostic_prev() end)
    nnoremap('<F12>', function() diag.lsp_jump_diagnostic_next() end)
    local codeaction = require('lspsaga.codeaction')
    nnoremap('<A-Return>', codeaction.code_action)
    vnoremap('<A-Return>', codeaction.range_code_action)
end)
