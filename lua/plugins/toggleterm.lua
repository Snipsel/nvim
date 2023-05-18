return {
    {   'akinsho/toggleterm.nvim', version='*',
        keys = {
            { '<C-CR>', desc="Open Toggleterm" },
        },
        config=function()
            require('toggleterm').setup{
                open_mapping = '<C-CR>',
                direction = 'float'
            }
        end
    }
}
