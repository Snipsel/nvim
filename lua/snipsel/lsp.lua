require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd" }
})


local on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         {buffer=bufnr})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    {buffer=bufnr})
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition,     {buffer=bufnr})
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {buffer=bufnr})
    vim.keymap.set('n', '<leader>K',  vim.lsp.buf.hover,          {buffer=bufnr})
end

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                library = { -- make language server aware of vim runtime files
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                }
            }
        }
    }
}

--local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").clangd.setup {
    on_attach = on_attach,
}

