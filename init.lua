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

-- gui settings
vim.o.guifont = "SauceCodePro Nerd Font,Noto Color Emoji:h11:#h-none"

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

-- move help files to floating window
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = 'SnipselInit',
--     callback = function()
--         -- early-out if not help buffer
--         if vim.bo.buftype ~= 'help' then return end
-- 
--         -- early-out if already floating
--         if vim.api.nvim_win_get_config(0).relative ~= '' then return end
-- 
--         local ui = vim.api.nvim_list_uis()[1]
--         vim.api.nvim_win_set_config(0, {
--             relative = 'editor',
--             width = 80-2,
--             height = ui.height-3,
--             col = ui.width/2 - (80-2)/2,
--             row = 2,
--             style = 'minimal',
--             border = 'rounded',
--             external = false,
--             focusable = true,
--             title = vim.fn.expand('%'),
--         })
--         vim.o.laststatus = 0
--         vim.api.nvim_win_set_option(0, 'winhl', 'Normal:Normal')
--     end
-- })

-- require('snipsel.packer').startup(function(use)
--     -- useful commands
-- 
--     -- LEAP: s=forward, S=backward, gs=other windows
--     use{'ggandor/leap.nvim',
--         requires={'tpope/vim-repeat'},
--         config=function()
--             require('leap').add_default_mappings(true)
--         end
--     }
-- 
--     -- color scheme
--     use{'morhetz/gruvbox', config = "require('snipsel.gruvbox')" }
-- 
--     -- learn keys!
--     use{"folke/which-key.nvim",
--         config = function()
--             require("which-key").setup { }
--         end
--     }
-- 
--     -- show changed lines in git repo with green/red lines
--     use{'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }
-- 
--     -- terminal
--     use{'akinsho/toggleterm.nvim', tag='*', config=function()
--         require('toggleterm').setup({
--             open_mapping = [[<c-\>]],
--             direction='float'
--         })
--     end}
-- 
--     -- autocompletion & snippets
--     use{'hrsh7th/nvim-cmp',
--         requires={
--             'hrsh7th/cmp-buffer',
--             'hrsh7th/cmp-path',
--             'hrsh7th/cmp-cmdline',
--             'onsails/lspkind.nvim', -- pretty pictograms in completion window
--             'L3MON4D3/LuaSnip', -- snippet engine
--             'saadparwaiz1/cmp_luasnip',
--             'rafamadriz/friendly-snippets', -- some nice default snippets
--         },
--         config = "require('snipsel.cmp')",
--     }
-- 
--     -- beautiful ui
--     use{'glepnir/lspsaga.nvim', branch='main',
--         config = function()
--             require('lspsaga').setup({
--                 move_in_saga = { prev = '<C-k>', next = '<C-j>' },
--                 finder_action_keys = { open = '<CR>' },
--                 definition_action_keys = { edit = '<CR>' },
--                 symbol_in_winbar = {
--                     separator = ' ', -- no separator
--                 }
--             })
--         end
--     }
-- 
--     -- language server
--     use{'williamboman/mason-lspconfig.nvim',
--         requires = {
--             'williamboman/mason.nvim',
--             'neovim/nvim-lspconfig',
--             'hrsh7th/cmp-nvim-lsp', -- completion integration
--         },
--         after = {'nvim-cmp','lspsaga.nvim'},
--         config = "require('snipsel.lsp')",
--     }
-- 
--     -- file browser
--     use{'nvim-tree/nvim-tree.lua',
--         requires = {
--             'nvim-tree/nvim-web-devicons'
--         },
--         config = "require('snipsel.nvim-tree')",
--     }
-- 
--     -- fuzzy search
--     use {'nvim-telescope/telescope.nvim', branch = '0.1.x',
--         requires = {
--             {'nvim-lua/plenary.nvim'},
--             {'nvim-telescope/telescope-fzf-native.nvim', run='make'},
--             {'nvim-tree/nvim-web-devicons'},
--         },
--         config = "require('snipsel.telescope')"
--     }
-- 
--     -- buffer line at the top
--     use{'akinsho/bufferline.nvim', tag = '*',
--         requires = 'nvim-tree/nvim-web-devicons',
--         config = function() require('snipsel.bufferline') end
--     }
-- end)

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

-- unused keys by neovim
-- 1) function keys
-- 2) alt-keys
-- 3) following ctrl-keys in all modes: ^Q ^S
--    - here, ^Q quits the buffer, and ^S saves the buffer
-- 4) following ctrl-keys in normal mode:
--   ^@  (equal to ^space)
--   ^H  (mapped to h)
--   ^J  (mapped to j)
--   ^N  (mapped to j)
--   ^K  (mapped to k)
--   ^P  (mapped to k)
--   ^L  (mapped to l)
--   ^M  (same as <CR>)
--   ^K  (free)
--   ^[  (= ^Esc )
--   ^_  (= ^/ )
--   ^\  (part 'reserved for extentions' whatever that means)
--   ^<CR> (here mapped to toggleterm)
-- 5) following keys in normal mode:
--  <bs> mapped to h
--    +  (mapped to <CR>)
--    K  (man page finder, not that useful)
--    S  mapped to cc, used by vim-surround
--    Y  mapped to y$ in neovim
--    _  almost identical to <CR>
--    s  mapped to cl
-- 6) not that useful keys in normal mode
--    x  mapped to dl ( may be useful to repeatedly use t
--    H  cursor to line N from the top of screen
--    L  cursor to line N from the bottom of the screen
--   ^B  scroll N full-screens backwards
--   ^F  scroll N full-screens forwards

function print_keymap()
    local strdisplaywidth = require('plenary.strings').strdisplaywidth
    local align_str = require('plenary.strings').align_str
    local map = {
        ['left top'] = {
            {
                {"󰌒",  'n newer entry in jump list'},
                {'󰘶󰌒',  ''},
                {"󰘴󰌒", 'go to last accessed tab (g󰌒)'},
            },{
                { "'", 'cursor to marked line'},
                { '"', 'select register'},
                {"󰘴'", "→ '"},
                { '`', 'cursor to mark'},
            },{
                { ',', 'repeat f/t/F/T reversed'},
                { '<', 'dedent motion'},
                {'󰘴,', '→ ,'},
            },{
                { '.', 'repeat last action'},
                { '>', 'indent motion'},
                {'󰘴.', '→ .'},
            },{
                { 'p', 'paste after cursor'},
                { 'P', 'paste before cursor'},
                {'󰘴p', '→ k'},
                { '+', '→ ↲'},
            },{
                { 'y', 'yank'},
                { 'Y', '→ y$'},
                {'󰘴y', 'scroll up'},
                { '~', 'toggle case'},
            }
        },

        ['left middle'] = {
            {
                {'⇱',  'normal mode'},
                {'󰘶⇱', ''},
                {'󰘴⇱', '→ ⇱'},
            },{
                {'a',  'append after char'},
                {'A',  'append after line'},
                {'󰘴a', 'add to number'},
                {'[',  'bracket command'}
            },{
                {'o',  'insert below'},
                {'O',  'insert above'},
                {'󰘴o', 'older jump location'},
                {'!',  'filter motion'},
            },{
                {'e',  'cursor end of word'},
                {'E',  'cursor end of WORD'},
                {'󰘴e', 'scroll line up'},
                {'(',  'cursor sentence back'},
            },{
                {'u',  'undo'},
                {'U',  'undo on line'},
                {'󰘴u', 'scroll half-screen up'},
                {'{',  'prev paragraph'},
            },{
                {'i',  'insert before char'},
                {'I',  'insert before line'},
                {'󰘴i', '→ 󰌒'},
                {'^',  'cursor to first char of line'},
            }
        },

        ['left bottom'] = {
            {
                {'\\',  ''},
                {'|',   'cursor to column N'},
                {'󰘴\\', ''},
            },{
                {';', 'repeat last f/t/F/T forwards'},
                {':', 'Ex command'},
                {'󰘴;', '→ ;'},
            },{
                {'q', 'start/stop macro or edit : ? /'},
                {'Q', 'replay last recorded macro'},
                {'󰘴q', '→ ;'},
            },{
                {'j', 'cursor down'},
                {'J', 'join line below'},
                {'󰘴j','→ j'},
            },{
                {'k', 'cursor up'},
                {'K', 'lookup keyword under cursor'},
                {'󰘴k',''},
            },{
                {'x', '→ dl delete char'},
                {'X', '→ dh backspace char'},
                {'󰘴x','subtract number'},
            }
        },

        ['thumbs'] = {
            {
                {'␣', 'leader'},
                {'', ''}, -- shift space impossible on keyboard
                {'󰘴␣','→ W'}, -- says unmapped, but i<C-v> says it's received as <C-Space>, and behaves like W
                -- prob sneakily mapped by nvim-cmp?
            },{
                {'⌫',  '→ h'},
                {'󰘶⌫', '→ b'},
                {'󰘴⌫', '→ B'},
            }
        },

        ['right top'] = {
            {
                {'f', 'find forward in line'},
                {'F', 'find backward in line'},
                {'󰘴f','scroll screen forward'},
                {'#', 'search back for word at cursor'}
            },{
                {'g', 'g command'},
                {'G', 'cursor to line N (default last)'},
                {'󰘴g','display file name and pos'},
                {'*', 'search forward for word at cursor'}
            },{
                {'c', 'change {motion}'},
                {'C', '→ c$'},
                {'󰘴c','cancel (search) command'},
                {'%', 'match next () [] {} on line'},
            },{
                {'r', 'replace character'},
                {'R', 'replace mode'},
                {'󰘴r','redo'},
                {'&', '→ :s↲ repeat last substitution'},
            },{
                {'l', 'cursor right'},
                {'L', 'cursor to line from bottom of screen'},
                {'󰘴l','redraw screen'},
                {'@', 'run macro'},
            },{
                {'-', 'linewise start of prev line'},
                {'_', 'linewise start of next-1 line'},
                {'󰘴-',''},
            }
        },

        ['right middle'] = {
            {
                {'d', 'cursor right'},
                {'D', '→ d$'},
                {'󰘴d','scroll down half a screen'},
                {'$', 'end of line'},
            },{
                {'h', 'cursor left'},
                {'H', 'cursor to line from top of screen'},
                {'󰘴h','→ h'},
                {'}', 'next paragraph'},
            },{
                {'t', 'till character'},
                {'T', 'till character backward'},
                {'󰘴t','jump to older tag'},
                {')', 'next sentence'},
            },{
                {'n', 'next match'},
                {'N', 'prev match'},
                {'󰘴n','→ j'},
                {'=', 'auto indent region'},
            },{
                {'s', '→ xi'},
                {'S', '→ cc'},
                {'󰘴s',''},
                {']', 'bracket command'},
            },{
                {'↲',  'cursor to start of next line'},
                {'󰘶↲', ''}, -- unmapped but mysteriously does pgdn or something?
                {'󰘴↲', ''}, -- mapped to toggleterm
            }
        },

        ['right bottom'] = {
            {
                {'b', 'cursor back word'},
                {'B', 'cursor back WORD'},
                {'󰘴b','scroll full screen back'},
            },{
                {'m', 'set mark'},
                {'M', 'cursor to middle line of screen'},
                {'󰘴m','→ ↲'},
            },{
                {'w', 'cursor word forward'},
                {'W', 'cursor WORD forward'},
                {'󰘴w','window command'},
            },{
                {'v', 'visual mode'},
                {'V', 'v-line mode'},
                {'󰘴v','v-block mode'},
            },{
                {'z', 'z command'},
                {'ZZ', 'close window, save buffer'},
                {'󰘴z','suspend program'},
                {'ZQ', 'close window, discard buffer'},
            },{
                {'/', 'search forward'},
                {'?', 'search backward'},
                {'󰘴/',''},
            }
        }
    }

    -- count width of columns
    local longest_key  = {0,0,0,0}
    local longest_desc = {0,0,0,0}
    for groupidx,group in pairs(map) do
        for _,row in ipairs(group) do
            for i,entry in ipairs(row) do
                longest_key[i]  = math.max(longest_key[i],  strdisplaywidth(entry[1]))
                longest_desc[i] = math.max(longest_desc[i], strdisplaywidth(entry[2]))
            end
        end
    end

    local function print_group(groupname)
        print(' ')
        --print(string.rep(' ', longest_key[1]) .. ' ' .. groupname)
        for _,row in ipairs(map[groupname]) do
            local line = {}
            for i,entry in ipairs(row) do
                table.insert(line, align_str(entry[1], longest_key[i], false))
                table.insert(line, align_str(entry[2], longest_desc[i], false))
            end
            print(table.concat(line, ' '))
        end
    end

    print_group('left top')
    print_group('left middle')
    print_group('left bottom')
    print_group('thumbs')
    print_group('right top')
    print_group('right middle')
    print_group('right bottom')
end

local nmap = {
    ['␣']  = {--[[ unset space --]]        n='<NOP>', v='<NOP>'},
    ['␣/'] = {'Clear search buffer',       n=':noh↲'},
    ['␣Q'] = {'Quit neovim',               n=':confirm quita↲'},

    -- window management
    ['␣q'] = {'Quit window',               n= close_window},

    ['␣h'] = {'Go to window to the left',  n='↑w↑h'},
    ['␣j'] = {'Go to window below',        n='↑w↑j'},
    ['␣k'] = {'Go to window above',        n='↑w↑k'},
    ['␣l'] = {'Go to window to the right', n='↑w↑l'},

    ['␣v'] = {'Vertical split',            n=':vsplit↲'},
    ['␣s'] = {'Split horizontal',          n=':split↲'},

    -- buffer management
    ['↑l'] = {'Go to next buffer',         n=':BufferLineCycleNext↲'},
    ['↑h'] = {'Go to previous buffer',     n=':BufferLineCyclePrev↲'},
    ['↑q'] = {'Quit buffer',               n= close_buffer},
    ['↑s'] = {'Save buffer',               n=':update↲',
                                           v='↑c:update↲gv',
                                           i='↑o:update↲'},
    ['↑u'] = {'Go up by half a screen',    n='↑uzz'},
    ['↑d'] = {'Go down by half a screen',  n='↑dzz'},

    -- visual navigation instead of line-based navigation
      j    = {'Move down one line',        n='gj', v='gj'},
      k    = {'Move up one line',          n='gk', v='gk'},
    ['$']  = {'Move down one line',        n='g$', v='g$'},
    ['^']  = {'Move down one line',        n='g^', v='g^'},
}

local function convert_keys(s)
    s = string.gsub(s, '␣',  '<leader>')
    s = string.gsub(s, '↑(.)', '<C-%1>')
    s = string.gsub(s, '⎇(.)', '<M-%1>')
    s = string.gsub(s, '↲',  '<CR>')
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

