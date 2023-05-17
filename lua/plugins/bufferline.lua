local function starts_with(str, prefix)
    return string.sub(str,1,#prefix) == prefix
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
    if os.getenv('SSH_CONNECTION') then table.insert(status, '') end
    if has_vpn  then table.insert(status, '󱠾') end
    if has_lan  then table.insert(status, '󰌘') end
    if has_wifi then table.insert(status, '󰖩') end
    return table.concat(status,' ')
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

return { 'akinsho/bufferline.nvim', version = '*', 
    dependencies = 'nvim-tree/nvim-web-devicons', 
    lazy = false, 
    config = function()
        require('bufferline').setup{
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
    end
}
