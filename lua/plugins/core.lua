return {
{'ellisonleao/gruvbox.nvim', lazy=false, priority=1000, config = function()
        vim.o.background = 'dark'
        require('gruvbox').setup{} -- defaults should be sane
        vim.cmd('colorscheme gruvbox')
    end},
'tpope/vim-surround',
'tpope/vim-repeat',
{'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup{} end }
}
