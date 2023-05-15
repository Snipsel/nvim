local bufferline = require('bufferline')

vim.o.showcmd = true
vim.o.showcmdloc = 'tabline'

-- create some custom colors
local SnipselColors = vim.api.nvim_create_augroup("SnipselColors", {clear=true})
vim.api.nvim_create_autocmd("ColorScheme", { group=SnipselColors, callback=function()
    -- colors grabbed from gruvbox
    local blue   = '#83a598'
    local yellow = '#fabd2f'
    local orange = '#fe8019'
    local red    = '#fb4934'
    local green  = '#b8bb26'
    local black  = '#282828'
    local gray   = '#a89984'
    local bg     = '#161616'

    vim.api.nvim_set_hl(0,'SnipselNormal', {fg=black, bg=gray,   bold=true})
    vim.api.nvim_set_hl(0,'SnipselInsert', {fg=black, bg=blue,   bold=true})
    vim.api.nvim_set_hl(0,'SnipselCommand',{fg=black, bg=green,  bold=true})
    vim.api.nvim_set_hl(0,'SnipselReplace',{fg=black, bg=red,    bold=true})
    vim.api.nvim_set_hl(0,'SnipselVisual', {fg=black, bg=yellow, bold=true})

    vim.api.nvim_set_hl(0,'SnipselNormalInv', {fg=gray,   bg=bg, bold=true})
    vim.api.nvim_set_hl(0,'SnipselInsertInv', {fg=blue,   bg=bg, bold=true})
    vim.api.nvim_set_hl(0,'SnipselCommandInv',{fg=green,  bg=bg, bold=true})
    vim.api.nvim_set_hl(0,'SnipselReplaceInv',{fg=red,    bg=bg, bold=true})
    vim.api.nvim_set_hl(0,'SnipselVisualInv', {fg=yellow, bg=bg, bold=true})
end})

local function starts_with(str, prefix)
    return string.sub(str,1,#prefix) == prefix
end

local function check_network_status()
    local has_wifi = false
    local has_lan  = false
    local has_vpn  = false
    for interface,_ in pairs(vim.loop.interface_addresses()) do
        if starts_with(interface, 'wl') then
            has_wifi = true
        elseif starts_with(interface, 'en') then
            has_lan = true
        elseif starts_with(interface, 'ci') then
            has_vpn = true
        end
    end

    local status = {}
    if has_vpn then table.insert(status, '󱠾') end
    table.insert(status,has_wifi and '󰖩' or '󰖪')
    table.insert(status,has_lan  and '󰌘' or '󰌙')
    return table.concat(status,' ')
end

-- refresh bufferline on mode change
local snipsel_refresh_status = vim.api.nvim_create_augroup('SnipselRefreshStatus',{clear=true})
vim.api.nvim_create_autocmd({'ModeChanged','CursorMoved','CursorMovedI'},{
    group = snipsel_refresh_status,
    callback = function(_)
        vim.cmd('redrawtabline')
        vim.cmd('redraw')
    end
})

local set_colors = function()
    local blue   = '#83a598'
    local yellow = '#fabd2f'
    local orange = '#fe8019'
    local red    = '#fb4934'
    local green  = '#b8bb26'
    local black  = '#282828'
    local gray   = '#a89984'
    local bg = '#161616'

    vim.api.nvim_set_hl(0,'SnipselNormal', {fg=black, bg=gray,  bold=true})
    vim.api.nvim_set_hl(0,'SnipselInsert', {fg=black, bg=blue,   bold=true})
    vim.api.nvim_set_hl(0,'SnipselCommand',{fg=black, bg=green,  bold=true})
    vim.api.nvim_set_hl(0,'SnipselReplace',{fg=black, bg=red,    bold=true})
    vim.api.nvim_set_hl(0,'SnipselVisual', {fg=black, bg=yellow, bold=true})

    vim.api.nvim_set_hl(0,'SnipselNormalInv', {fg=gray,  bg=bg,  bold=true})
    vim.api.nvim_set_hl(0,'SnipselInsertInv', {fg=blue,  bg=bg,   bold=true})
    vim.api.nvim_set_hl(0,'SnipselCommandInv',{fg=green, bg=bg,  bold=true})
    vim.api.nvim_set_hl(0,'SnipselReplaceInv',{fg=red,   bg=bg,    bold=true})
    vim.api.nvim_set_hl(0,'SnipselVisualInv', {fg=yellow,bg=bg, bold=true})
end
set_colors()

local mode = function()
    local tab = {
        ['c'] ='%#SnipselCommandInv#%#SnipselCommand# COMMAND %#SnipselCommandInv#',
        ['R'] ='%#SnipselReplaceInv#%#SnipselReplace# REPLACE %#SnipselReplaceInv#',
        ['^V']=  '%#SnipselVisualInv#%#SnipselVisual# V-BLOCK %#SnipselVisualInv#',
        ['n'] =  '%#SnipselNormalInv#%#SnipselNormal# NORMAL %#SnipselNormalInv#',
        ['i'] =  '%#SnipselInsertInv#%#SnipselInsert# INSERT %#SnipselInsertInv#',
        ['v'] =  '%#SnipselVisualInv#%#SnipselVisual# VISUAL %#SnipselVisualInv#',
        ['V'] =  '%#SnipselVisualInv#%#SnipselVisual# V-LINE %#SnipselVisualInv#',
        ['t'] =  '%#SnipselNormalInv#%#SnipselNormal# TERMINAL %#SnipselNormalInv#',
        ['?'] =  '%#SnipselNormalInv#%#SnipselNormal#  ? ? ?  %#SnipselNormalInv#',
    }
    return '%-17(' .. (tab[vim.fn.strtrans(vim.fn.mode())] or tab['?']) ..  '%#BufferLineFill# %S%)'
end

local git = function()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == '' then
        return ''
    end
    return '%#BufferLineFill#' .. '  ' .. git_info.head .. ' '
end

local leftline = function()
    return table.concat{
        mode(),
        git(),
    }
end

local rightline = function()
    return '%#BufferLineFill# ' .. check_network_status() .. ' %{strftime("%d %b %H:%M")} '
end

bufferline.setup{
    options = {
        separator_style = 'slant',
        custom_areas = {
            left = function()
                return { { text = leftline() } }
            end,
            right = function()
                return { {text = rightline()} }
            end,
        }
    }
}


