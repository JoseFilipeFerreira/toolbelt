local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
        'morhetz/gruvbox',
        config = function()
            vim.cmd([[colorscheme gruvbox]])
            vim.cmd([[set background=dark]])
            vim.cmd([[let g:gruvbox_contrast_dark = 'hard']])
            vim.cmd([[highlight Normal ctermbg=None]])
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

    -- Formating and Errors
    use 'tpope/vim-commentary'
    use 'alvan/vim-closetag'
    use 'godlygeek/tabular'

    -- Language Server Protocol
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-cmp',
        config = function() require('plugins.lsp-config') end,
    }
    use {
        'tami5/lspsaga.nvim',
        branch = "nvim51",
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
