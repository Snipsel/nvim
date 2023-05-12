require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'clangd' }
})

require('lspsaga').setup({
    move_in_saga = { prev = '<C-k>', next = '<C-j>' },
    finder_action_keys = { open = '<CR>' },
    definition_action_keys = { edit = '<CR>' }
})

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
    local opt = { noremap = true, silent=true, buffer = bufnr }
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         opt)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    opt)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,     opt)
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opt)
    vim.keymap.set('n', '<leader>K',  vim.lsp.buf.hover,          opt)
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

