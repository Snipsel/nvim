require('lualine').setup({
    options = {
        icons_enabled=true,
        theme='gruvbox',
        globalstatus=true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
})
