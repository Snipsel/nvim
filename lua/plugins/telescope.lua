return { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
        {'nvim-lua/plenary.nvim'},
        {'nvim-tree/nvim-web-devicons'},
        {'nvim-telescope/telescope-fzf-native.nvim', build='make'},
        {'nvim-telescope/telescope-file-browser.nvim'},
    },
    keys = {
        {'<space>o', function() require('telescope').extensions.file_browser.file_browser() end, desc = 'Open file' },
        {'<space>g', function() require('telescope.builtin').live_grep()  end, desc = 'Grep files'  },
        {'<space>b', function() require('telescope.builtin').buffers()    end, desc = 'Find buffer' },
        {'<space>?', function() require('telescope.builtin').help_tags()  end, desc = 'Help'        },
    },
    config = function()
        require('telescope').setup {}
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('file_browser')
    end,
}
