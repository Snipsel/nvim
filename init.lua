-- vim config
vim.opt.hlsearch = true -- highlight search
vim.opt.number = true -- default numbers
vim.opt.mouse = 'a' -- enable mouse
vim.opt.ignorecase = true -- case insensitive...
vim.opt.smartcase = true -- ... except when some characters are capitalized
vim.opt.termguicolors = true -- allow all the colors
vim.opt.clipboard = 'unnamedplus' -- xclip must be installed, otherwise clipboard does not work
vim.opt.splitright = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- linebreaks
vim.opt.breakindent = true -- make sure line-wrapped text is indented
vim.opt.showbreak = '↳ '
vim.opt.linebreak = true -- wrap on words

-- visual navigation
vim.keymap.set('n', 'j', 'gj', {silent=true})
vim.keymap.set('v', 'j', 'gj', {silent=true})
vim.keymap.set('n', 'k', 'gk', {silent=true})
vim.keymap.set('v', 'k', 'gk', {silent=true})
vim.keymap.set('n', '$', 'g$', {silent=true})
vim.keymap.set('v', '$', 'g$', {silent=true})
vim.keymap.set('n', '^', 'g^', {silent=true})
vim.keymap.set('v', '^', 'g^', {silent=true})

-- tabs and indentation
vim.opt.expandtab = true -- tabs are spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- ctrl-s to save
vim.keymap.set('n', '<C-s>', ':w<CR>', {silent=true})
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>a', {silent=true})

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>/',':noh<CR>', {silent = true }) -- clear search
vim.keymap.set('n', '<leader>t',':tabnew ') -- open new tab

return require('snipsel.packer').startup(function(use)
    -- useful commands
    use 'tpope/vim-surround'

    -- color scheme
    use{'morhetz/gruvbox', config = "require('snipsel.gruvbox')" }

    -- autocompletion & snippets
    use{'hrsh7th/nvim-cmp',
        requires={
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
        },
        config = "require('snipsel.cmp')",
    }

    -- language server
    use{'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        config = "require('snipsel.lsp')",
    }

    -- file browser
    use{'nvim-tree/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons'
        },
        config = "require('snipsel.nvim-tree')",
    }

    -- fuzzy search
    use {'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run='make'},
            {'kyazdani42/nvim-web-devicons'},
        },
        config = "require('snipsel.telescope')"
    }

    -- nice status line
    use{'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        config = "require('snipsel.lualine')",
    }
end)

