-- vim config
vim.opt.hlsearch = true -- highlight search
vim.opt.number = true -- default numbers
vim.opt.mouse = 'a' -- enable mouse in (a)ll modes
vim.opt.ignorecase = true -- case insensitive...
vim.opt.smartcase = true -- ... except when some characters are capitalized
vim.opt.termguicolors = true -- allow all the colors
vim.opt.clipboard = 'unnamedplus' -- xclip must be installed, otherwise clipboard does not work
vim.opt.splitkeep = 'cursor' -- split so that the cursor does not move
vim.o.ch = 0 -- FINALLY as of nvim 0.8 we can hide the command line below the status line

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- linebreaks
vim.opt.breakindent = true -- make sure line-wrapped text is indented
vim.opt.showbreak = '↳ '
vim.opt.linebreak = true -- wrap on words

-- visual navigation instead of line-based navigation
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
vim.opt.tabstop = 4 -- visualize <TAB> characters as 4-spaces wide
vim.opt.softtabstop = 4 -- make tab key move to the next 4-column boundry
vim.opt.shiftwidth = 4 -- number of spaces to auto-indent

-- ctrl-s to save
vim.keymap.set('n', '<C-s>', ':w<CR>', {silent=true})
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>a', {silent=true})

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>/',':noh<CR>', {silent = true }) -- clear search
vim.keymap.set('n', '<leader>t',':tabnew ') -- open new tab

-- auto select root
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('AutoRoot', {}),
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        if path == '' then return end
        local root_names = {'.git', 'compile-commands.json', 'Makefile', 'README.md', 'README.txt'}
        local root_file = vim.fs.find(root_names, { path=path, upward=true})[1]
        if root_file ~= nil then
            vim.fn.chdir(vim.fs.dirname(root_file))
        end
    end
})

return require('snipsel.packer').startup(function(use)
    -- useful commands
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat' -- make dot-repeats (.) work as intended

    -- LEAP: s=forward, S=backward, gs=other windows
    use{'ggandor/leap.nvim',
        requires={'tpope/vim-repeat'},
        config=function()
            require('leap').add_default_mappings(true)
        end
    }

    -- color scheme
    use{'morhetz/gruvbox', config = "require('snipsel.gruvbox')" }

    -- show changed lines in git repo with green/red lines
    use{'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }

    -- terminal
    use{'akinsho/toggleterm.nvim', tag='*', config=function()
        require('toggleterm').setup({
            open_mapping = [[<c-\>]], 
            direction='float'
        })
    end}

    -- autocompletion & snippets
    use{'hrsh7th/nvim-cmp',
        requires={
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind.nvim', -- pretty pictograms in completion window
            'L3MON4D3/LuaSnip', -- snippet engine
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets', -- some nice default snippets
        },
        config = "require('snipsel.cmp')",
    }

    -- language server
    use{'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp', -- completion integration
            {'glepnir/lspsaga.nvim', branch='main'}, -- better ui
        },
        after = 'nvim-cmp',
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

