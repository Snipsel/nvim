-- vim config
vim.o.hlsearch = true -- highlight search
vim.wo.number = true -- default numbers
vim.o.mouse = 'a' -- enable mouse
vim.o.ignorecase = true -- case insensitive...
vim.o.smartcase = true -- ... except when some characters are capitalized
vim.o.termguicolors = true -- allow all the colors
vim.opt.clipboard = 'unnamedplus' -- xclip must be installed, otherwise clipboard does not work

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- linebreaks
vim.o.breakindent = true -- make sure line-wrapped text is indented
vim.o.showbreak = '↳ '
vim.o.linebreak = true -- wrap on words

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
vim.o.expandtab = true -- tabs are spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- ctrl-s to save
vim.keymap.set('n', '<C-s>', ':w<CR>', {silent=true})
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>a', {silent=true})

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>/',':noh<CR>', {silent = true }) -- clear search
vim.keymap.set('n', '<leader>t',':tabnew ') -- open new tab

-- install packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- automatically run PackerCompile if this file is changed
vim.api.nvim_exec(
    [[
        augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
        augroup end
    ]],
    false
)

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use{'morhetz/gruvbox',
        config = "require('config.gruvbox')",
    }

    use{'williamboman/mason-lspconfig.nvim',
        requires = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        config = "require('config.lsp')",
    }

    use{'nvim-tree/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons'
        },
        config = "require('config.nvim-tree')",
    }

    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = {
            'nvim-lua/plenary.nvim'
        },
        config = "require('config.telescope')"
    }

    use{'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        config = "require('config.lualine')",
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

