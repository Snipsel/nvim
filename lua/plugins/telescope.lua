return { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
        {'nvim-lua/plenary.nvim'},
        {'nvim-tree/nvim-web-devicons'},
        {'nvim-telescope/telescope-fzf-native.nvim', build='make'},
        {'nvim-telescope/telescope-file-browser.nvim'},
    },
    keys = {
        {'<C-e>', function() require('telescope').extensions.file_browser.file_browser() end, desc = 'Edit file' },
        {'<C-g>', function() require('telescope.builtin').live_grep()  end, desc = 'Grep files'  },
        {'<C-b>', function() require('telescope.builtin').buffers()    end, desc = 'Find buffer' },
        {'gh',    function() require('telescope.builtin').help_tags()  end, desc = 'Get help'    },
    },
    config = function()
        require('telescope').setup {}
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('file_browser')
    end,
}
