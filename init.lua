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
vim.o.cmdheight = 0 -- FINALLY as of nvim 0.8 we can hide the command line below the status line
vim.o.laststatus = 0 -- no status line, only tab line!
vim.o.timeout = false
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- gui settings
vim.o.guifont = "SauceCodePro Nerd Font Mono,Noto Color Emoji"
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_no_idle = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- linebreaks
vim.opt.breakindent = true -- make sure line-wrapped text is indented
vim.opt.linebreak = true -- wrap on words
vim.opt.showbreak = '↳ '

-- tabs and indentation
vim.opt.expandtab = true -- tabs are spaces
vim.opt.tabstop = 4 -- visualize <TAB> characters as 4-spaces wide
vim.opt.softtabstop = 4 -- make tab key move to the next 4-column boundry
vim.opt.shiftwidth = 4 -- number of spaces to auto-indent

vim.api.nvim_create_augroup('SnipselInit', {})

-- move help files to floating window
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'SnipselInit',
    callback = function()
        -- early-out if not help buffer
        if vim.bo.buftype ~= 'help' then return end

        -- early-out if already floating
        if vim.api.nvim_win_get_config(0).relative ~= '' then return end

        local ui = vim.api.nvim_list_uis()[1]
        vim.api.nvim_win_set_config(0, {
            relative = 'editor',
            width = 80-2,
            height = ui.height-3,
            col = ui.width/2 - (80-2)/2,
            row = 2,
            style = 'minimal',
            border = 'rounded',
            external = false,
            focusable = true,
            title = vim.fn.expand('%'),
        })
        vim.o.laststatus = 0
        vim.api.nvim_win_set_option(0, 'winhl', 'Normal:Normal')
    end
})

-- auto select root
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'SnipselInit',
    callback = function()
        if vim.bo.buftype ~= '' then return end -- only apply this to regular buffers
        local path = vim.api.nvim_buf_get_name(0)
        if path == '' then return end
        local root_names = {'.git', 'compile-commands.json', 'Makefile', 'README.md', 'README.txt'}
        local root_file = vim.fs.find(root_names, { path=path, upward=true})[1]
        if root_file ~= nil then
            vim.fn.chdir(vim.fs.dirname(root_file))
        end
    end
})

require('snipsel.packer').startup(function(use)
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
end)

local function close_window()
    local window_count = #vim.api.nvim_list_wins()
    if window_count>1 then
        vim.api.nvim_win_hide(0)
    else
        vim.cmd('confirm quita')
    end
end

local function close_buffer()
    local listed_buffer_count = #vim.fn.getbufinfo({ buflisted=1 })
    if listed_buffer_count>1 then
        require('bufferline').cycle(-1)
        vim.cmd('bd#')
        vim.cmd('redrawtabline')
    else
        vim.cmd('confirm quit')
    end
end

local nmap = {
    ['␣']  = {--[[ unset space --]]        n='<NOP>', v='<NOP>'},
    ['␣/'] = {'Clear search buffer',       n=':noh↲'},
    ['␣Q'] = {'Quit neovim',               n=':confirm quita↲'},

    -- window management
    ['␣q'] = {'Quit window',               n= close_window},

    ['␣h'] = {'Go to window to the left',  n='↑w↑h'},
    ['␣j'] = {'Go to window below',        n='↑w↑j'},
    ['␣k'] = {'Go to window above',        n='↑w↑k'},
    ['␣l'] = {'Go to window to the right', n='↑w↑l'},

    ['␣v'] = {'Vertical split',            n=':vsplit↲'},
    ['␣s'] = {'Split hoorizontal',         n=':split↲'},

    -- buffer management
    ['↑q'] = {'Quit buffer',               n= close_buffer},
    ['↑l'] = {'Go to next buffer',         n=':BufferLineCycleNext↲'},
    ['↑h'] = {'Go to previous buffer',     n=':BufferLineCyclePrev↲'},
    ['↑s'] = {'Save file',                 n=':update↲',
                                           v='↑c:update↲gv',
                                           i='↑o:update↲'},
    ['↑u'] = {'Go up by half a screen',    n='↑uzz'},
    ['↑d'] = {'Go down by half a screen',  n='↑dzz'},

    -- visual navigation instead of line-based navigation
      j    = {'Move down one line',        n='gj', v='gj'},
      k    = {'Move up one line',          n='gk', v='gk'},
    ['$']  = {'Move down one line',        n='g$', v='g$'},
    ['^']  = {'Move down one line',        n='g^', v='g^'},

    -- fuzzy finding goodness
    ['␣o'] = {'Open file',     n=require('telescope.builtin').find_files },
    ['␣g'] = {'Grep files',    n=require('telescope.builtin').live_grep },
    ['␣b'] = {'Find buffer',   n=require('telescope.builtin').buffers },
    ['␣?'] = {'Find Help',     n=require('telescope.builtin').help_tags },
}

local function convert_keys(s)
    s = string.gsub(s, '␣',  '<leader>')
    s = string.gsub(s, '↑(.)', '<C-%1>')
    s = string.gsub(s, '⎇(.)', '<M-%1>')
    s = string.gsub(s, '↲',  '<CR>')
    return s
end

for keys,cmd in pairs(nmap) do
    local opt = {silent=true, noremap=true, desc=cmd[1]}
    for c in ('nvi'):gmatch'.' do
        if cmd[c] then
            local command = type(cmd[c])=='string' and convert_keys(cmd[c]) or cmd[c]
            vim.keymap.set(c, convert_keys(keys), command, opt)
        end
    end
end

