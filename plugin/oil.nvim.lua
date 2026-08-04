vim.pack.add({
    'https://github.com/stevearc/oil.nvim',
    -- Git
    'https://github.com/malewicz1337/oil-git.nvim',
    -- Diagnostic
    'https://github.com/JezerM/oil-lsp-diagnostics.nvim',
})

local oil = require('oil')

require('oil-git').setup({
    debounce_ms = 50,
    show_file_highlights = true,
    show_directory_highlights = true,
    show_file_symbols = true,
    show_directory_symbols = true,
    show_ignored_files = false, -- Show ignored file status
    show_ignored_directories = false, -- Show ignored directory status
    show_branch = false, -- Show current Git branch in oil buffers
    branch_format = ' %s', -- Format string for branch display
    symbol_position = 'eol', -- "eol", "signcolumn", or "none"
    can_use_signcolumn = nil, -- Optional callback(bufnr): nil|bool|string
    ignore_gitsigns_update = false, -- Ignore GitSignsUpdate events (fallback for flickering)
    debug = false, -- false, "minimal", or "verbose"

    symbols = {
        file = {
            added = '+',
            modified = '~',
            renamed = '->',
            deleted = 'D',
            copied = 'C',
            conflict = '!',
            untracked = '?',
            ignored = 'o',
        },
        directory = {
            added = '*',
            modified = '*',
            renamed = '*',
            deleted = '*',
            copied = '*',
            conflict = '!',
            untracked = '*',
            ignored = 'o',
        },
    },
})

require('oil-lsp-diagnostics').setup()

oil.setup({
    default_file_explorer = true,
    delete_to_trash = true,

    columns = {
        'icon',
        'size',
    },

    view_options = {
        -- Some loverly comment
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
        end,
    },

    buf_options = {
        buflisted = true,
        bufhidden = 'hide',
    },

    lsp_file_methods = {
        autosave_changes = true,
    },

    -- Documentation for myself
    keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },

    win_options = {
        foldcolumn = '0',
    },

    skip_confirm_for_simple_edits = true,

    float = {
        padding = 4,
        border = 'rounded',
    },

    confirmation = {
        border = 'rounded',
    },

    progress = {
        border = 'rounded',
    },
})
