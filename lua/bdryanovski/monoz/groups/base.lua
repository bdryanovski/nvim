-- monoz base groups
-- Forked from monoglow.nvim. monoglow includes code derived from tokyonight.nvim,
-- licensed under the Apache License, Version 2.0.

local util = require('bdryanovski.monoz.util')

local M = {}

--- Merge a style attribute table (bold/italic/...) into a highlight table.
---@param hl table
---@param style? table
---@return table
local function ext(hl, style)
    if style then
        return vim.tbl_extend('force', hl, style)
    end
    return hl
end

---@type monoz.HighlightsFn
function M.get(c, opts)
    local s = opts.styles or {}
    return {
        -- editor:text
        Normal = { fg = c.fg, bg = opts.transparent and c.none or c.bg }, -- Normal text
        NormalNC = 'Normal', -- Normal text in non-current windows
        Title = { fg = c.title }, -- Titles for output from ":set all", ":autocmd" etc.
        Whitespace = { fg = c.special.whitespace }, -- "nbsp", "space", "tab", "multispace", "lead" and "trail" in 'listchars'

        -- editor:nontext
        NonText = { fg = c.gray4 }, -- '@' at the end of the window, and characters from 'showbreak'

        -- editor:visual
        Visual = { bg = c.visual }, -- Visual mode selection
        VisualNOS = 'Visual', -- Visual mode selection when Vim is "Not Owning the Selection"
        LspReferenceText = { bg = c.lsp_ref }, -- Used for highlighting "text" references

        -- editor:float
        NormalFloat = { fg = c.fg, bg = c.bg_popup }, -- Normal text in floating windows
        FloatBorder = { fg = c.border, bg = c.bg_popup }, -- Border of floating windows
        FloatTitle = { fg = c.title }, -- Title of floating windows

        -- editor:cursor
        Cursor = { fg = c.bg, bg = c.fg }, -- Character under the cursor
        CursorLine = { bg = c.cur_line }, -- Screen-line at the cursor
        CursorLineNr = { fg = c.cur_line_nr }, -- Like LineNr when 'cursorline' is set
        LineNr = { fg = c.fg_gutter }, -- Line number for ":number" and ":#" commands
        SignColumn = { bg = opts.transparent and c.none or c.bg }, -- Column where signs are displayed

        -- editor:search
        CurSearch = 'IncSearch', -- Current search match under cursor
        IncSearch = { fg = c.black, bg = c.glow }, -- 'incsearch' highlighting; also used for ":s///c" replacement
        Search = { fg = c.glow, bold = true }, -- Last search pattern highlighting (see 'hlsearch')
        Substitute = 'Search', -- :substitute replacement text highlighting

        -- editor:fold
        Folded = { fg = c.gray4 }, -- Line used for closed folds
        FoldColumn = { fg = c.gray4 }, -- 'foldcolumn'

        -- editor:diff
        DiffAdd = { fg = c.bg, bg = c.diff.add }, -- diff mode: Added line |diff.txt|
        DiffChange = { fg = c.bg, bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
        DiffDelete = { fg = c.bg, bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
        DiffText = { fg = c.bg, bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|

        -- editor:menu
        Pmenu = { fg = c.fg, bg = opts.transparent and c.none or c.bg_menu }, -- Popup menu: normal item
        PmenuSel = { fg = c.black, bg = c.glow, bold = true }, -- Popup menu: selected item
        PmenuSbar = { fg = c.gray5, bg = c.gray3 }, -- Popup menu: scrollbar
        PmenuThumb = { fg = c.gray3, bg = c.gray5 }, -- Popup menu: Thumb of the scrollbar
        PmenuExtra = { fg = c.gray4 }, -- Popup menu: extra text (e.g. kind label)
        PmenuKind = { fg = c.cmp.kind }, -- Popup menu: kind icon/text

        -- editor:statusline
        StatusLine = { fg = c.fg_sidebar, bg = c.bg_statusline }, -- Status line of current window
        StatusLineNC = { fg = c.fg_gutter, bg = c.bg_statusline }, -- Status lines of not-current windows
        WinBar = 'StatusLine', -- Window bar of current window
        WinBarNC = 'StatusLineNC', -- Window bar of not-current windows

        -- editor:ui (other)
        EndOfBuffer = { fg = opts.eob and c.gray2 or c.bg }, -- Filler lines (~) after the end of the buffer
        WinSeparator = { fg = c.border }, -- Separator between window splits

        -- editor:misc
        Directory = { fg = c.fs.dir }, -- Directory names (and other special names in listings)

        -- syntax
        Conditional = ext({ fg = c.syntax.conditional, bold = opts.glow }, s.conditionals), -- if, then, else, endif, switch, etc.
        Exception = ext({ fg = c.syntax.keyword_exception, bold = opts.glow }, s.keywords), -- try, catch, throw, etc.
        Function = ext({ fg = c.syntax.func_def, bold = opts.glow }, s.functions), -- Function name (also: methods for classes)
        Identifier = { fg = c.syntax.type, bold = opts.glow }, -- Any variable name
        Keyword = ext({ fg = c.syntax.keyword, bold = opts.glow }, s.keywords), -- Any other keyword
        Label = 'Keyword', -- case, default, etc.
        PreProc = 'Keyword', -- Generic Preprocessor
        Repeat = ext({ fg = c.syntax.loop, bold = opts.glow }, s.loops), -- for, do, while, etc.
        Special = { fg = c.syntax.special }, -- Any special symbol
        Statement = 'Keyword', -- Any statement
        Type = ext({ fg = c.syntax.type }, s.types), -- int, long, char, etc.
        Variable = ext({ fg = c.syntax.var }, s.variables), -- Variable names (Vim9 script)

        -- syntax:constants
        Boolean = ext({ fg = c.syntax.boolean }, s.booleans), -- true, false
        Character = 'String', -- 'c', '\n'
        Constant = { fg = c.syntax.const }, -- Any constant
        Float = 'Number', -- Floating point constant: 2.3e10
        Number = ext({ fg = c.syntax.number }, s.numbers), -- Numeric constant: 234, 0xff
        String = ext({ fg = c.syntax.string }, s.strings), -- String constant: "this is a string"

        -- syntax:punctuation
        Quote = 'String', -- Quote characters around strings
        Operator = ext({ fg = c.syntax.operator, bold = opts.glow }, s.operators), -- "sizeof", "+", "*", etc.
        Delimiter = { fg = c.syntax.punctuation }, -- Character that needs attention

        -- syntax:comments
        Comment = ext({ fg = c.syntax.comment, italic = true }, s.comments), -- Any comment

        -- diagnostics
        DiagnosticError = { fg = c.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticHint = { fg = c.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticInfo = { fg = c.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticOk = { fg = c.ok }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticWarn = { fg = c.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default

        DiagnosticVirtualTextError = { bg = util.blend_bg(c.error, 0.1), fg = c.error }, -- Used for "Error" diagnostic virtual text
        DiagnosticVirtualTextHint = { bg = util.blend_bg(c.hint, 0.1), fg = c.hint }, -- Used for "Hint" diagnostic virtual text
        DiagnosticVirtualTextInfo = { bg = util.blend_bg(c.info, 0.1), fg = c.info }, -- Used for "Information" diagnostic virtual text
        DiagnosticVirtualTextOk = { bg = util.blend_bg(c.ok, 0.1), fg = c.ok }, -- Used for "Ok" diagnostic virtual text
        DiagnosticVirtualTextWarn = { bg = util.blend_bg(c.warning, 0.1), fg = c.warning }, -- Used for "Warning" diagnostic virtual text

        DiagnosticUnderlineError = { undercurl = true, sp = c.error }, -- Used to underline "Error" diagnostics
        DiagnosticUnderlineHint = { undercurl = true, sp = c.hint }, -- Used to underline "Hint" diagnostics
        DiagnosticUnderlineInfo = { undercurl = true, sp = c.info }, -- Used to underline "Information" diagnostics
        DiagnosticUnderlineOk = { undercurl = true, sp = c.ok }, -- Used to underline "Ok" diagnostics
        DiagnosticUnderlineWarn = { undercurl = true, sp = c.warning }, -- Used to underline "Warning" diagnostics

        -- webdevicon
        DevIconDefault = { fg = c.icon }, -- Default icon for nvim-web-devicons

        -- syntax:preproc (for non-TS users)
        Structure = 'Type', -- struct, union, enum, etc.
        StorageClass = 'Keyword', -- static, register, volatile, etc.
        Typedef = 'Type', -- typedef
        Include = 'Keyword', -- #include
        Define = 'Keyword', -- #define
        Macro = 'Keyword', -- Same as Define
        PreCondit = 'Keyword', -- #if, #else, #endif, etc.

        -- syntax:special (for non-TS users)
        SpecialChar = 'Special', -- Special character in a constant
        Tag = 'Special', -- Can use CTRL-] on this
        Debug = 'Special', -- Debugging statements
        SpecialComment = 'Special', -- Special things inside a comment

        -- syntax:misc (for non-TS users)
        Underlined = { underline = true }, -- Text that stands out, HTML links
        Ignore = { fg = c.gray3 }, -- Left blank, hidden
        Error = { fg = c.error }, -- Any erroneous construct
        Todo = { fg = c.todo, bold = true }, -- TODO, FIXME, XXX, etc.

        -- diff:standard (used by @diff.plus/minus/delta via Nvim defaults)
        Added = { fg = c.diff.add }, -- Added line in a diff
        Changed = { fg = c.diff.change }, -- Changed line in a diff
        Removed = { fg = c.diff.delete }, -- Removed line in a diff

        -- editor:matching
        MatchParen = { fg = c.glow, bold = true }, -- Character under the cursor or just before it if matching

        -- editor:spell
        SpellBad = { undercurl = true, sp = c.error }, -- Word that is not recognized by the spellchecker
        SpellCap = { undercurl = true, sp = c.warning }, -- Word that should start with a capital
        SpellRare = { undercurl = true, sp = c.info }, -- Word that is recognized as rarely used
        SpellLocal = { undercurl = true, sp = c.hint }, -- Word from another region
    }
end

return M
