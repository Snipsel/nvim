return {
{'morhetz/gruvbox',lazy=false, priority=1000, config = function() vim.cmd([[colorscheme gruvbox]]) end},
'tpope/vim-surround',
'tpope/vim-repeat',
{'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup{} end }
}
