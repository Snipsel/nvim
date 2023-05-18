return {
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        -- dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects' } },
        config = function()
            require('nvim-treesitter.configs').setup{
                highlight = { enable = true, disable = { 'lua', 'c', 'cpp' } },
                indent = { enable = true },
                context_commentstring = { enable = true, enable_autocmd = false },
                auto_install = true,
                ensure_installed = {
                    'glsl',
                    'bash', 'regex', 'vim', 'vimdoc',
                    'html', 'javascript',
                    'markdown', 'markdown_inline',
                    'json', 'yaml',
                    'python',
                }
            }
        end
    }
}

