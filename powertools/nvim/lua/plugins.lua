-- luacheck: globals vim
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system(
      {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

return require('packer').startup({function(use)
    -- Meta
    use 'wbthomason/packer.nvim'
    use 'b0o/mapx.nvim'
    use {'tweekmonster/startuptime.vim', disable = true }

    -- Theme
    use {
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        -- Telescope
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        -- Autocomplete
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                    }
                end
            })
            vim.cmd("colorscheme kanagawa-wave")
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            vim.opt.showmode = false
            require('plugins.lualine')
        end
    }

    -- File Browsing
    use {
        'scrooloose/nerdtree',
        config = function()
            vim.g.NERDTreeSortOrder = {'include/$', 'src/$'}
            vim.g.NERDTreeDirArrows = 1
            vim.g.NERDTreeQuitOnOpen = 1
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function() require('plugins.telescope') end,
        module = {'telescope', 'telescope.builtin'},
    }

    -- Syntax Highlighting
    use {
        'machakann/vim-highlightedyank',
        config = function() vim.g.highlightedyank_highlight_duration = 100 end
    }
    use 'sheerun/vim-polyglot'
    use {
        'folke/todo-comments.nvim',
        requires = "nvim-lua/plenary.nvim",
        config = function() require('plugins.todo-comments') end,
    }

    -- Formating
    use 'tpope/vim-commentary'
    use 'godlygeek/tabular'

    -- Language Server Protocol
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-cmp',
        config = function() require('plugins.lsp-config') end,
    }
    use {
        'tami5/lspsaga.nvim',
        config = function() require('plugins.lspsaga') end,
        after = "nvim-lspconfig"
    }

    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            {'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            {'hrsh7th/cmp-path', after = 'nvim-cmp' },
            {'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
            {'hrsh7th/vim-vsnip', after = 'nvim-cmp' },
            {'hrsh7th/cmp-vsnip', after = 'vim-vsnip' },
        },
        config = function() require('plugins.cmp') end,
        event = "VimEnter *"
    }

    -- set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end,
config = {
    display = {
        open_fn = require('packer.util').float
}}})
