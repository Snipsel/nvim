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

    {   'simrat39/rust-tools.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
        },
        config = function()
            local rt = require("rust-tools")
            rt.setup({
                server = {
                    on_attach = function(_, bufnr)
                      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                      -- Code action groups
                      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                    end,
                },
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
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'clangd', 'rust_analyzer' }
            })

            local lspconfig = require('lspconfig')

            local on_attach = function(client, bufnr)
                local function map(lhs, rhs, desc)
                    vim.keymap.set('n', lhs, rhs, { noremap = true, silent=true, buffer = bufnr, desc=desc })
                end
                map('<leader>rn', vim.lsp.buf.rename,         'Rename (lsp)')
                map('<leader>ca', vim.lsp.buf.code_action,    'Code action (lsp)')
                map('gd',         vim.lsp.buf.definition,     'Go to definition (lsp)')
                map('gi',         vim.lsp.buf.implementation, 'Go to implementation (lsp)')
                map('K',          vim.lsp.buf.hover,          'Look up information (lsp)')
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig['lua_ls'].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = { -- make language server aware of vim runtime files
                                [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                [vim.fn.stdpath('config') .. '/lua'] = true,
                            }
                        }
                    }
                }
            })

            lspconfig['clangd'].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            ---lspconfig['rust_analyzer'].setup({
            ---    on_attach = on_attach,
            ---    capabilities = capabilities,
            ---})
        end
    }
}
