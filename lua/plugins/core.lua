return {

{'ellisonleao/gruvbox.nvim', lazy=false, priority=1000, config = function()
        vim.o.background = 'dark'
        require('gruvbox').setup{} -- defaults should be sane
        vim.cmd('colorscheme gruvbox')
    end},

{'NvChad/nvim-colorizer.lua', lazy=false, config = function()
        require('colorizer').setup{
            filetypes = {"*"},
            user_default_options = { names = false },
        }
    end},

{'lewis6991/gitsigns.nvim', lazy=false, config = function() require('gitsigns').setup{} end },

{'gbprod/substitute.nvim', lazy=false, config=function()
        vim.keymap.set("n", "s",  require('substitute').operator, { noremap = true })
        vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
        vim.keymap.set("n", "S",  require('substitute').eol, { noremap = true })
        --vim.keymap.set("x", "s",  require('substitute').visual, { noremap = true })

        vim.keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
        vim.keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })
        --vim.keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })

        -- vim.keymap.set("n", "x",  require('substitute.exchange').operator, { noremap = true })
        -- vim.keymap.set("n", "xx", require('substitute.exchange').line,     { noremap = true })
        -- vim.keymap.set("x", "X",  require('substitute.exchange').visual,   { noremap = true })
        -- vim.keymap.set("n", "xc", require('substitute.exchange').cancel,   { noremap = true })
    end },

{'kylechui/nvim-surround', version='*', lazy=false, config=function()
        require('nvim-surround').setup{
            keymaps = {
                normal          = "ys",
                normal_cur      = "yss",
                normal_line     = "yS",
                normal_cur_line = "ySS",
                visual          = "S",
                visual_line     = "gS",
                delete          = "ds",
                change          = "cs",
            }
        }
    end}

}
