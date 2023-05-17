return {

    {   'glepnir/lspsaga.nvim',
        branch='main',
        config = function()
            require('lspsaga').setup({
                move_in_saga = { prev = '<C-k>', next = '<C-j>' },
                finder_action_keys = { open = '<CR>' },
                definition_action_keys = { edit = '<CR>' },
                symbol_in_winbar = {
                    separator = ' ',
                }
            })
        end
    },

    {   'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',

        },
        config = function()
        end
    }
}
