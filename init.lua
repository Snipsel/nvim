-- vim config
vim.opt.hlsearch = true -- highlight search
vim.opt.number = true -- default numbers
vim.opt.mouse = 'a' -- enable mouse in (a)ll modes
vim.opt.ignorecase = true -- case insensitive...
vim.opt.smartcase = true -- ... except when some characters are capitalized
vim.opt.termguicolors = true -- allow all the colors
vim.opt.clipboard = 'unnamedplus' -- xclip must be installed, otherwise clipboard does not work
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.cmdheight = 0 -- FINALLY as of nvim 0.8 we can hide the command line below the status line
vim.o.laststatus = 0 -- no status line, only tab line!
vim.o.timeout = false
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.foldenable = false

-- gui settings
-- vim.o.guifont = "SauceCodePro Nerd Font,Noto Color Emoji:h16:#h-none"
font_size = 16
function set_font_size(size)
    font_size = size
    vim.o.guifont = string.format("LigaSauceCodePro Nerd Font,Noto Color Emoji:h%d:#h-none", font_size)
end

function change_font_size(diff)
    set_font_size(font_size + diff)
end
set_font_size(16);

vim.keymap.set('n', '<C-ScrollWheelUp>',   function() change_font_size( 1) end, {})
vim.keymap.set('n', '<C-ScrollWheelDown>', function() change_font_size(-1) end, {})

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- linebreaks
vim.opt.breakindent = true -- make sure line-wrapped text is indented
vim.opt.linebreak = true -- wrap on words
vim.opt.showbreak = '↳ '

-- tabs and indentation
vim.opt.expandtab = true -- tabs are spaces
vim.opt.tabstop = 4 -- visualize <TAB> characters as 4-spaces wide
vim.opt.softtabstop = 4 -- make tab key move to the next 4-column boundry
vim.opt.shiftwidth = 4 -- number of spaces to auto-indent

vim.api.nvim_create_augroup('SnipselInit', {clear = true})

-- auto select root
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'SnipselInit',
    callback = function()
        if vim.bo.buftype ~= '' then return end -- only apply this to regular buffers
        local path = vim.api.nvim_buf_get_name(0)
        if path == '' then return end
        local root_names = {'.git', 'compile-commands.json', 'Makefile', 'README.md', 'README.txt'}
        local root_file = vim.fs.find(root_names, { path=path, upward=true})[1]
        if root_file ~= nil then
            vim.fn.chdir(vim.fs.dirname(root_file))
        end
    end
})

-- create some custom colors
vim.api.nvim_create_autocmd("ColorScheme", { group='SnipselInit', callback=function()
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

-- lazyvim bootstrap and run
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
  "https://github.com/folke/lazy.nvim.git", "--branch=stable",
  lazypath, })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

local function close_window()
    local window_count = #vim.api.nvim_list_wins()
    if window_count>1 then
        vim.api.nvim_win_hide(0)
    else
        vim.cmd('confirm quita')
    end
end

local function close_buffer()
    local listed_buffer_count = #vim.fn.getbufinfo({ buflisted=1 })
    if listed_buffer_count>1 then
        require('bufferline').cycle(-1)
        vim.cmd('bd#')
        vim.cmd('redrawtabline')
    else
        vim.cmd('confirm quit')
    end
end

local nmap = {
    ['␣']  = {--[[ unset space --]]        n='<NOP>', v='<NOP>'},
    ['␣/'] = {'Clear search buffer',       n=':noh↲'},

    -- window management
    ['↑h'] = {'Go to window to the left',  n='↑w↑h'},
    ['↑j'] = {'Go to window below',        n='↑w↑j'},
    ['↑k'] = {'Go to window above',        n='↑w↑k'},
    ['↑l'] = {'Go to window to the right', n='↑w↑l'},

    ['Z']  = {'Close window',               n= close_window},
    ['↑z'] = {'Close neovim',               n=':confirm quita↲' },
    ['|']  = {'Vertical split',             n=':vsplit↲'},
    ['↑-'] = {'Horizontal split',           n=':split↲'},

    -- buffer management
    [ 'L'] = {'Go to next buffer',         n=':BufferLineCycleNext↲'},
    [ 'H'] = {'Go to previous buffer',     n=':BufferLineCyclePrev↲'},
    ['↑q'] = {'Quit buffer',               n= close_buffer},
    ['↑s'] = {'Save buffer',               n=':update↲',
                                           v='↑c:update↲gv',
                                           i='↑o:update↲'},

    -- center screen on cursor after move
    ['↑u'] = {'Go up by half a screen',    n='↑uzz'},
    ['↑d'] = {'Go down by half a screen',  n='↑dzz'},

    -- visual navigation instead of line-based navigation
      j    = {'Move down one line',        n='gj', v='gj'},
      k    = {'Move up one line',          n='gk', v='gk'},
    ['$']  = {'Move down one line',        n='g$', v='g$'},
    ['^']  = {'MOVE down one line',        n='g^', v='g^'},
}

local function convert_keys(s)
    s = string.gsub(s, '␣',    '<leader>')
    s = string.gsub(s, '↑(.)', '<C-%1>')
    s = string.gsub(s, '↲',    '<CR>')
    return s
end

for keys,cmd in pairs(nmap) do
    local opt = {silent=true, noremap=true, desc=cmd[1]}
    for c in ('nvi'):gmatch'.' do
        if cmd[c] then
            local command = type(cmd[c])=='string' and convert_keys(cmd[c]) or cmd[c]
            vim.keymap.set(c, convert_keys(keys), command, opt)
        end
    end
end

