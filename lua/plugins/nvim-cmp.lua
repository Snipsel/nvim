return{
    -- autocompletion & snippets
    {   'hrsh7th/nvim-cmp',
        lazy = false, -- TODO lazy load
        dependencies={
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind.nvim', -- pretty pictograms in completion window
            'L3MON4D3/LuaSnip', -- snippet engine
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets', -- some nice default snippets
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            require('luasnip/loaders/from_vscode').lazy_load() -- init friendly-snippets

            vim.opt.completeopt = "menu,menuone,noselect"

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand( args.body )
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                  ['<C-k>'] = cmp.mapping.select_prev_item(),
                  ['<C-j>'] = cmp.mapping.select_next_item(),
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = false }),
                }),

                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                }),

                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = '…'
                    }),
                },
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
            })
        end
    }
}
