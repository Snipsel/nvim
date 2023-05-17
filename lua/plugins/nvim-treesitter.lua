return { 
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects' } },
    config = function() 
        require('nvim-treesitter').setup{
            highlight = { enable = true },
            indent = { enable = true },
            context_commentstring = { enable = true, enable_autocmd = false },
            ensure_installed = {
                'bash', 'regex', 'vim', 'vimdoc',
                'html', 'javascript',
                'markdown', 'markdown_inline',
                'json', 'yaml',
                'python',
            }
        } 
    end
}

