return {
-- start plugins, always load these! -------------------------------------------

-- colorscheme
{'morhetz/gruvbox',lazy=false, priority=1000, config = function() vim.cmd([[colorscheme gruvbox]]) end},
'tpope/vim-surround',
'tpope/vim-repeat',


-- lazy plugins ----------------------------------------------------------
--{'lewis6991/gitsigns.nvim'}
--{'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = {
--    'nvim-lua/plenary.nvim',
--   {'nvim-telescope/telescope-fzf-native.nvim', run='make'},
--    'nvim-tree/nvim-web-devicons' }},
--{'hrsh7th/nvim-cmp', dependencies = {
--    'hrsh7th/cmp-buffer',
--    'hrsh7th/cmp-path',
--    'hrsh7th/cmp-cmdline',
--    'onsails/lspkind.nvim', -- pretty pictograms in completion window
--    'L3MON4D3/LuaSnip', -- snippet engine
--    'saadparwaiz1/cmp_luasnip',
--    'rafamadriz/friendly-snippets' }},
--use{'williamboman/mason-lspconfig.nvim', dependencies = {
--        'williamboman/mason.nvim',
--        'neovim/nvim-lspconfig',
--        'hrsh7th/cmp-nvim-lsp', -- completion integration
--    },
--    after = {'nvim-cmp','lspsaga.nvim'},
--    config = "require('snipsel.lsp')",
--}
}
