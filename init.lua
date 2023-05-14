-- vim config
vim.opt.hlsearch = true -- highlight search
vim.opt.number = true -- default numbers
vim.opt.mouse = 'a' -- enable mouse in (a)ll modes
vim.opt.ignorecase = true -- case insensitive...
vim.opt.smartcase = true -- ... except when some characters are capitalized
vim.opt.termguicolors = true -- allow all the colors
vim.opt.clipboard = 'unnamedplus' -- xclip must be installed, otherwise clipboard does not work
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.ch = 0 -- FINALLY as of nvim 0.8 we can hide the command line below the status line
vim.o.ls = 0 -- no status line, only tab line!

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

-- disable key timout
vim.o.timeout = false

local close_window = function()
    local window_count = #vim.api.nvim_list_wins()
    if window_count>1 then
        vim.cmd('hide')
    else
        vim.cmd('confirm quita')
    end
end

local close_buffer = function()
    local listed_buffer_count = #vim.fn.getbufinfo({ buflisted=1 })
    if listed_buffer_count>1 then
        vim.cmd('BufferLineCyclePrev')
        vim.cmd('bd#')
        vim.cmd('redrawtabline')
    else
        vim.cmd('confirm quit')
    end
end

-- window management commands
vim.keymap.set('n', '<leader>Q',':confirm quita<CR>', {silent=true,desc='Quit neovim'})
vim.keymap.set('n', '<leader>q',close_window, {silent=true,desc='Quit window (but keep the buffer)'})

vim.keymap.set('n', '<leader>v', ':vsp<CR>',   {silent=true,desc='Vertical split'})
vim.keymap.set('n', '<leader>s', ':sp<CR>',    {silent=true,desc='Split Horizontal'})
vim.keymap.set('n', '<C-h>',     '<C-w><C-h>', {silent=true,desc='Go to window to the left'})
vim.keymap.set('n', '<C-j>',     '<C-w><C-j>', {silent=true,desc='Go to window below'})
vim.keymap.set('n', '<C-k>',     '<C-w><C-k>', {silent=true,desc='Go to window above'})
vim.keymap.set('n', '<C-l>',     '<C-w><C-l>', {silent=true,desc='Go to window to the right'})

-- buffer management
vim.keymap.set('n', 'L',     ':BufferLineCycleNext<CR>', {silent=true,desc='Go to next buffer'})
vim.keymap.set('n', 'H',     ':BufferLineCyclePrev<CR>', {silent=true,desc='Go to previous buffer'})
vim.keymap.set('n', '<C-q>', close_buffer,               {silent=true,desc='Quit buffer (but keep window open)'})

-- ctrl-s to save
vim.keymap.set('n', '<C-s>', ':update<CR>',        {silent=true, desc="Save file"})
vim.keymap.set('v', '<C-s>', '<C-c>:update<CR>gv', {silent=true, desc="Save file"})
vim.keymap.set('i', '<C-s>', '<C-o>:update<CR>',   {silent=true, desc="Save file"})

-- remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>', '<Nop>', { silent = true })

-- clear search like this, since ctrl-l is already used
vim.keymap.set('n', '<leader>/', ':noh<cr>', { silent = true })

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

    -- learn keys!
    use{"folke/which-key.nvim",
        config = function()
            require("which-key").setup { }
        end
    }

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

    -- beautiful ui
    use{'glepnir/lspsaga.nvim', branch='main',
        config = function()
            require('lspsaga').setup({
                move_in_saga = { prev = '<C-k>', next = '<C-j>' },
                finder_action_keys = { open = '<CR>' },
                definition_action_keys = { edit = '<CR>' },
                symbol_in_winbar = {
                    separator = ' ', -- no separator
                }
            })
        end
    }

    -- language server
    use{'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp', -- completion integration
        },
        after = {'nvim-cmp','lspsaga.nvim'},
        config = "require('snipsel.lsp')",
    }

    -- file browser
    use{'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons'
        },
        config = "require('snipsel.nvim-tree')",
    }

    -- fuzzy search
    use {'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run='make'},
            {'nvim-telescope/telescope-fzf-native.nvim', run='make'},
            {'nvim-tree/nvim-web-devicons'},
        },
        config = "require('snipsel.telescope')"
    }

    -- buffer line at the top
    use{'akinsho/bufferline.nvim', tag = '*',
        requires = 'nvim-tree/nvim-web-devicons',
        config = function() require('snipsel.bufferline') end
    }

    -- nice status line
    -- use{'nvim-lualine/lualine.nvim',
    --     requires = {
    --         'nvim-tree/nvim-web-devicons',
    --     },
    --     after = 'lspsaga.nvim',
    --     config = "require('snipsel.lualine')",
    -- }
end)

