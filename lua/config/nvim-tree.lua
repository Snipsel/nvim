require("nvim-tree").setup{
    on_attach = function(bufnr)
        local map = function(key,op,desc)
            vim.keymap.set('n', key, op, {buffer=bufnr, desc=desc})
        end
        local api = require('nvim-tree.api')

        map('l', api.node.open.edit, 'Expand folder or go to file')
        map('h', api.node.navigate.parent_close, 'Close Parent folder')
    end
}

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

