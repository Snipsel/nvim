vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>')

return {'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy=false,
    config = function()
        require("nvim-tree").setup{
            on_attach = function(bufnr)
                local map = function(key,op,desc)
                    vim.keymap.set('n', key, op, {buffer=bufnr, noremap=true, silent=true, nowait=true, desc=desc})
                end
                local api = require('nvim-tree.api')
                map('<CR>',   api.node.open.drop,                   'Open file if not already open')
                map('<S-CR>', api.node.open.drop,                   'Open file if not already open')
            end,
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true,
            }
        }
    end
}
