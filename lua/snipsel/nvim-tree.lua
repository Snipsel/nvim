require("nvim-tree").setup{
    on_attach = function(bufnr)
        local map = function(key,op,desc)
            vim.keymap.set('n', key, op, {buffer=bufnr, noremap=true, silent=true, nowait=true, desc=desc})
        end
        local api = require('nvim-tree.api')

        map('<CR>',   api.node.open.drop,                   'Open file if not already open')
        map('<S-CR>', api.node.open.drop,                   'Open file if not already open')

        -- map('o',      api.node.open.edit,                   'Open')
        -- map('<2-LeftMouse>',  api.node.open.edit,           'Open')

        -- map('<C-]>', api.tree.change_root_to_node,          'CD')
        -- map('<2-RightMouse>', api.tree.change_root_to_node, 'CD')

        -- map('<Tab>', api.node.open.preview,                 'Open Preview')
        -- map('O',     api.node.open.no_window_picker,        'Open: No Window Picker')
        -- map('<C-e>', api.node.open.replace_tree_buffer,     'Open: In Place')
        -- map('<C-t>', api.node.open.tab,                     'Open: New Tab')
        -- map('<C-v>', api.node.open.vertical,                'Open: Vertical Split')
        -- map('<C-x>', api.node.open.horizontal,              'Open: Horizontal Split')

        -- map('<BS>',  api.node.navigate.parent_close,        'Close Directory')
        -- map('q',     api.tree.close,                        'Close')

        -- map('<C-r>', api.fs.rename_sub,                     'Rename: Omit Filename')
        -- map('e',     api.fs.rename_basename,                'Rename: Basename')
        -- map('r',     api.fs.rename,                         'Rename')

        -- map('>',     api.node.navigate.sibling.next,        'Next Sibling')
        -- map('<',     api.node.navigate.sibling.prev,        'Previous Sibling')
        -- map('J',     api.node.navigate.sibling.last,        'Last Sibling')
        -- map('K',     api.node.navigate.sibling.first,       'First Sibling')

        -- map('a',     api.fs.create,                         'Create')

        -- map('x',     api.fs.cut,                            'Cut')
        -- map('c',     api.fs.copy.node,                      'Copy')
        -- map('p',     api.fs.paste,                          'Paste')

        -- map('d',     api.fs.remove,                         'Delete')
        -- map('D',     api.fs.trash,                          'Trash')

        -- map('y',     api.fs.copy.filename,                  'Copy Name')
        -- map('Y',     api.fs.copy.relative_path,             'Copy Relative Path')
        -- map('gy',    api.fs.copy.absolute_path,             'Copy Absolute Path')


        -- map('<C-k>', api.node.show_info_popup,              'Info')
        -- map('.',     api.node.run.cmd,                      'Run Command')
        -- map('-',     api.tree.change_root_to_parent,        'Up')
        -- map('bmv',   api.marks.bulk.move,                   'Move Bookmarked')
        -- map('B',     api.tree.toggle_no_buffer_filter,      'Toggle No Buffer')
        -- map('C',     api.tree.toggle_git_clean_filter,      'Toggle Git Clean')
        -- map('[c',    api.node.navigate.git.prev,            'Prev Git')
        -- map(']c',    api.node.navigate.git.next,            'Next Git')
        -- map('E',     api.tree.expand_all,                   'Expand All')
        -- map(']e',    api.node.navigate.diagnostics.next,    'Next Diagnostic')
        -- map('[e',    api.node.navigate.diagnostics.prev,    'Prev Diagnostic')
        -- map('F',     api.live_filter.clear,                 'Clean Filter')
        -- map('f',     api.live_filter.start,                 'Filter')
        -- map('g?',    api.tree.toggle_help,                  'Help')
        -- map('H',     api.tree.toggle_hidden_filter,         'Toggle Dotfiles')
        -- map('I',     api.tree.toggle_gitignore_filter,      'Toggle Git Ignore')
        -- map('m',     api.marks.toggle,                      'Toggle Bookmark')
        -- map('P',     api.node.navigate.parent,              'Parent Directory')
        -- map('R',     api.tree.reload,                       'Refresh')
        -- map('s',     api.node.run.system,                   'Run System')
        -- map('S',     api.tree.search_node,                  'Search')
        -- map('U',     api.tree.toggle_custom_filter,         'Toggle Hidden')
        -- map('W',     api.tree.collapse_all,                 'Collapse')
    end,

    -- allow others to change cwd and such
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    }

    -- auto close 

}

vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>')

