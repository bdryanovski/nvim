require('bdryanovski.custom.fold').setup({
    -- Fold level: levels above this are closed on file open
    -- level=2 means: 1,2 open, 3+ closed
    level = 1,

    -- Highlight group for line count
    hl_group = 'FoldedLineCount',

    -- Format for line count text (%d = number of lines)
    format = ' %d lines ',

    -- Icon shown before line count
    icon = '',
})

-- Customize the highlight (optional)
vim.api.nvim_set_hl(0, 'FoldedLineCount', { fg = '#7aa2f7', bg = '#2a2a3a', bold = true })
