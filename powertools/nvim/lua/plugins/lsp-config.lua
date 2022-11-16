-- luacheck: globals vim
local lsp = require('lspconfig')
local default_capabilities = require('cmp_nvim_lsp').default_capabilities
local au = require('utils.au')

local on_attach = function(client, bufnr)
        -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings
        local opts = { noremap = true, silent = true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)

        au.group('Format', function(g)
            g.BufWritePre = {
                '<buffer>',
                vim.lsp.buf.format
            }
        end)
end

lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = default_capabilities()
}

lsp.cmake.setup{
    on_attach = on_attach,
    capabilities = default_capabilities()
}

lsp.pyright.setup{
    on_attach = on_attach,
    capabilities = default_capabilities()
}

lsp.rust_analyzer.setup {
    on_attach = on_attach,
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
    capabilities = default_capabilities()
}

vim.cmd [[LspStart]]
