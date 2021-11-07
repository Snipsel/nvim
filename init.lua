-- vim config
vim.o.hlsearch = true -- highlight search
vim.wo.number = true -- default numbers
vim.o.mouse = 'a' -- enable mouse
vim.o.ignorecase = true -- case insensitive...
vim.o.smartcase = true -- ... except when some characters are capitalized
vim.o.termguicolors = true -- allow all the colors

-- tabs and indentation
vim.o.breakindent = true -- make sure line-wrapped text is indented
vim.o.showbreak = '↳ '
vim.o.expandtab = true -- tabs are spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- function to simplify key mappings
local function map(mode, lhs, rhs, opt)
    local options = {noremap=true}
    if opts then options = vim.tbl_extend('force',options, opts) end
    vim.api.nvim_set_keymap(mode,lhs,rhs,options)
end

--Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
map('n', '<leader>', '<Nop>', { silent = true })

map('n', '<leader>/',':noh<CR>', {silent = true }) -- clear search
map('n', '<leader>t',':tabnew ') -- open new tab

-- install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

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

-- plugins!
local function config_lsp()
    print("lspconfig gogogo!")
    -- generic vim autocomplete settings
    vim.o.completeopt = 'menuone,noselect'

    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    -- config language servers
    local nvim_lsp = require('lspconfig')
    local on_attach = function(_,bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end
    local servers = { 'clangd' }
    for _,lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities
        }
    end

    -- config autocomplete bindings
    local cmp = require('cmp')
    cmp.setup {
        mapping={
            ['<Tab>']   = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
            ['<S-Tab>'] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
            ['Space']   = function(fallback) if cmp.visible() then cmp.mapping.complete() else fallback() end end,
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.close(),
        },
        sources = {
            {name='nvim_lsp'}
        }
    }
end

local packer = require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- Package manager
	use {'morhetz/gruvbox', config= function() 
		vim.cmd('colorscheme gruvbox')
	end}

    use {'neovim/nvim-lspconfig'}
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-nvim-lsp', 
        requires={'hrsh7th/nvim-cmp','neovim/nvim-lspconfig'},
        config=config_lsp }

	if packer_bootstrap then
		require('packer').sync()
	end
end)


