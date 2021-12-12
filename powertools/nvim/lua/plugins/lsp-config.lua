local lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
local update_capabilities = require('cmp_nvim_lsp').update_capabilities
local au = require('utils.au')

local on_attach = function(autoformat)
    return function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings
        local opts = { noremap = true, silent = true }
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        if autoformat and client.resolved_capabilities.document_formatting then
            au.group('Format', function(g)
                g.BufWritePre = {
                    '<buffer>',
                    vim.lsp.buf.formatting_seq_sync
                }
            end)
            buf_set_keymap('n', '<leader>f', '<Cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>', opts)
        end
    end
end

lsp.clangd.setup {
    on_attach = on_attach(true),
    capabilities = update_capabilities(protocol.make_client_capabilities())
}

lsp.cmake.setup{
    on_attach = on_attach(true),
    capabilities = update_capabilities(protocol.make_client_capabilities())
}

-- lsp.bashls.setup {
--     on_attach = on_attach(true),
--     capabilities = update_capabilities(protocol.make_client_capabilities())
-- }

lsp.pyright.setup{
    on_attach = on_attach(true),
    capabilities = update_capabilities(protocol.make_client_capabilities())
}

lsp.rust_analyzer.setup {
    on_attach = on_attach(true),
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                autoreload = true
            },
            flags = {
                exit_timeout = 0,
            },
            checkOnSave = {
                command = "clippy"
            },
        }
    },
    capabilities = update_capabilities(protocol.make_client_capabilities())
}

vim.cmd [[LspStart]]
