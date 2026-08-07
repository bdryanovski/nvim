vim.pack.add({
    'https://github.com/rose-pine/neovim',
    'https://github.com/wnkz/monoglow.nvim',
    'https://github.com/oskarnurm/koda.nvim',
    'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/catppuccin/nvim',
    'https://github.com/vague-theme/vague.nvim',
    'https://github.com/kyzabuilds/xeno.nvim',
    'https://github.com/WTFox/luna.nvim',
})

require('rose-pine').setup({
    variant = 'moon', -- auto, main, moon, or dawn
    dark_variant = 'main', -- main, moon, or dawn
    dim_inactive_windows = true,
    extend_background_behind_borders = true,

    enable = {
        -- terminal = true,

        -- migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = 'muted',
        link = 'iris',
        panel = 'surface',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        note = 'pine',
        todo = 'rose',
        warn = 'gold',

        git_add = 'foam',
        git_change = 'rose',
        git_delete = 'love',
        git_dirty = 'rose',
        git_ignore = 'muted',
        git_merge = 'iris',
        git_rename = 'pine',
        git_stage = 'iris',
        git_text = 'rose',
        git_untracked = 'subtle',

        h1 = 'iris',
        h2 = 'foam',
        h3 = 'rose',
        h4 = 'gold',
        h5 = 'pine',
        h6 = 'foam',
    },

    palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
    },

    -- NOTE: Highlight groups are extended (merged) by default. Disable this
    -- per group via `inherit = false`
    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- StatusLine = { fg = "love", bg = "love", blend = 15 },
        -- VertSplit = { fg = "muted", bg = "muted" },
        -- Visual = { fg = "base", bg = "text", inherit = false },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

require('monoglow').setup({
    -- Change the "glow" color
    on_colors = function(colors)
        colors.glow = '#fd1b7c'
    end,
})

require('koda').setup({
    transparent = false, -- enable for transparent backgrounds

    -- Automatically enable highlights only for plugins installed by your plugin manager
    -- Currently only supports `lazy.nvim`, `mini.deps` and `vim.pack`
    auto = true, -- disable to load ALL available plugin highlights

    cache = true, -- caches the theme for better performance

    -- Style to be applied to different syntax groups
    -- Common use case would be to set either `italic = true` or `bold = true` for a desired group
    -- See `:help nvim_set_hl` for more valid values
    styles = {
        functions = { bold = true },
        keywords = {},
        comments = {},
        strings = {},
        constants = {}, -- includes numbers, booleans
    },

    -- Override colors for the active variant
    -- Available keys (e.g., 'func') can be found in lua/koda/palette/
    colors = {
        -- func = "#4078F2",
        -- keyword = "#A627A4",
    },

    -- You can modify or extend highlight groups using the `on_highlights` configuration option
    -- Any changes made take effect when highlights are applied
    on_highlights = function(hl, c)
        -- hl.LineNr = { fg = c.info } -- change a specific highlight to use a different palette color
        -- hl.Comment = { fg = c.emphasis, italic = true } -- modify a syntax group (add bold, italic, etc)
        -- hl.RainbowDelimiterRed = { fg = "#fb2b2b" } -- add a custom highlight group for another plugin
    end,
})

require('kanagawa').setup({
    compile = true,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = true },
    specialReturn = true,
    specialException = true,
    transparent = false,
    dimInactive = false,
    globalStatus = false,
    terminalColors = true,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = 'none',
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            -- Customize normal background
            NormalFloat = { bg = theme.ui.bg_p1 },
            -- Customize cursor line background
            CursorLineNr = { fg = theme.ui.fg_bright, bold = true },
        }
    end,
})

require('catppuccin').setup({
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = 'latte',
        dark = 'mocha',
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.55, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { 'italic' }, -- Change the style of comments
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = { 'italic' },
        booleans = {},
        properties = {},
        types = { 'italic' },
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        alpha = true,
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        treesitter_context = true,
        fzf = true,
        noice = true,
        notify = true,
        which_key = true,
        telescope = false,
        lsp_trouble = true,
        dap_ui = true,
        dap = {
            enabled = true,
            enable_ui = true,
        },
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { 'italic' },
                hints = { 'italic' },
                warnings = { 'italic' },
                information = { 'italic' },
                ok = { 'italic' },
            },
            underlines = {
                errors = { 'underline' },
                hints = { 'underline' },
                warnings = { 'underline' },
                information = { 'underline' },
                ok = { 'underline' },
            },
            inlay_hints = {
                background = true,
            },
        },
        mini = {
            enabled = true,
            indentscope_color = '',
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

require('vague').setup({
    transparent = true, -- don't set background
    -- disable bold/italic globally in `style`
    bold = true,
    italic = true,
    style = {
        -- "none" is the same thing as default. But "italic" and "bold" are also valid options
        boolean = 'bold',
        number = 'none',
        float = 'none',
        error = 'bold',
        comments = 'italic',
        conditionals = 'none',
        functions = 'none',
        headings = 'bold',
        operators = 'none',
        strings = 'none',
        variables = 'bold',

        -- keywords
        keywords = 'none',
        keyword_return = 'bold',
        keywords_loop = 'none',
        keywords_label = 'none',
        keywords_exception = 'none',

        -- builtin
        builtin_constants = 'bold',
        builtin_functions = 'none',
        builtin_types = 'bold',
        builtin_variables = 'none',
    },
    -- plugin styles where applicable
    -- make an issue/pr if you'd like to see more styling options!
    plugins = {
        cmp = {
            match = 'bold',
            match_fuzzy = 'bold',
        },
        dashboard = {
            footer = 'italic',
        },
        lsp = {
            diagnostic_error = 'bold',
            diagnostic_hint = 'none',
            diagnostic_info = 'italic',
            diagnostic_ok = 'none',
            diagnostic_warn = 'bold',
        },
    },

    -- Override colors
    colors = {
        bg = '#141415',
        inactiveBg = '#1c1c24',
        fg = '#cdcdcd',
        floatBorder = '#878787',
        line = '#252530',
        comment = '#606079',
        builtin = '#b4d4cf',
        func = '#c48282',
        string = '#e8b589',
        number = '#e0a363',
        property = '#c3c3d5',
        constant = '#aeaed1',
        parameter = '#bb9dbd',
        visual = '#333738',
        error = '#d8647e',
        warning = '#f3be7c',
        hint = '#7e98e8',
        operator = '#90a0b5',
        keyword = '#6e94b2',
        type = '#9bb4bc',
        search = '#405065',
        plus = '#7fa563',
        delta = '#f3be7c',
    },
})

local xeno = require('xeno')

xeno.color('aurora', '#3ddc97')
xeno.color('teal', '#2ec4b6')
xeno.color('cyan', '#4fd9e8')
xeno.color('ice', '#8ecae6')
xeno.color('frost', '#a8e6cf')
xeno.color('violet', '#9b7fd4')
xeno.color('indigo', '#7c93e0')
xeno.color('glow_pink', '#e39fc2')

xeno.theme('polarized', {
    background = '#0a141c',
    accent = '#3ddc97',
    foreground = '#c9dde2',
    properties = {
        contrast = 0.10,
        chroma = 0.05,
        lightness = -0.05,
        variation = 0.10,
    },
    integrations = {
        ghostty = {
            enabled = false,
            update_config = false,
        },
    },

    highlights = {
        editor = {
            CursorLineNr = { fg = '@frost.100', bold = true },
            MatchParen = { fg = '@frost.100', bold = true },
            Visual = { bg = xeno.opaque('@aurora.500', 0.18) },
            CursorLine = { bg = xeno.opaque('@teal.600', 0.06) },
            Search = { bg = xeno.opaque('@cyan.400', 0.25), fg = '@foreground.50' },
            IncSearch = { bg = xeno.opaque('@frost.300', 0.35), fg = '@background.950' },
        },

        syntax = {
            Comment = { fg = '@foreground.400', italic = true },
            Keyword = { fg = '@violet.300' },
            Conditional = { fg = '@indigo.300' },
            Function = { fg = '@teal.300' },
            Type = { fg = '@cyan.200' },
            String = { fg = '@aurora.100' },
            Number = { fg = '@frost.100' },
            Boolean = { fg = '@frost.100' },
            Variable = { fg = '@foreground.300' },
            Property = { fg = '@ice.300' },
            Operator = { fg = '@cyan.300' },
            Punctuation = { fg = '@foreground.400' },

            ['@keyword'] = { link = 'Keyword' },
            ['@keyword.return'] = { link = 'Keyword' },
            ['@keyword.function'] = { link = 'Conditional' },
            ['@keyword.conditional'] = { link = 'Conditional' },
            ['@keyword.repeat'] = { link = 'Conditional' },
            ['@keyword.operator'] = { fg = '@cyan.300' },
            ['@keyword.import'] = { fg = '@teal.400' },

            ['@function'] = { link = 'Function' },
            ['@function.builtin'] = { fg = '@cyan.100' },

            ['@type'] = { link = 'Type' },

            ['@string'] = { link = 'String' },
            ['@string.escape'] = { fg = '@ice.100' },

            ['@number'] = { link = 'Number' },
            ['@boolean'] = { link = 'Boolean' },

            ['@constant'] = { fg = '@frost.200' },
            ['@constant.builtin'] = { fg = '@glow_pink.100', bold = true },

            ['@variable'] = { link = 'Variable' },
            ['@variable.builtin'] = { fg = '@indigo.200' },

            ['@property'] = { link = 'Property' },

            ['@constructor'] = { fg = '@foreground.400' },

            ['@operator'] = { link = 'Operator' },
            ['@punctuation'] = { link = 'Punctuation' },
            ['@punctuation.bracket'] = { link = 'Punctuation' },
            ['@punctuation.delimiter'] = { link = 'Punctuation' },

            ['@lsp.type.variable'] = { link = '@variable' },
            ['@lsp.type.property'] = { link = '@property' },
            ['@lsp.type.function'] = { link = '@function' },
            ['@lsp.type.type'] = { link = '@type' },
            ['@lsp.type.keyword'] = { link = '@keyword' },
            ['@lsp.mod.declaration'] = { clear = true },
            ['@lsp.typemod.property.declaration'] = { link = '@property' },
        },
    },
    plugins = {
        ['ibhagwan/fzf-lua'] = {
            bg = xeno.background_950, -- Background color
            fg = xeno.foreground_300, -- Foreground text color
            border = xeno.background_800, -- Border color
            prompt_fg = xeno.accent_200, -- Prompt text color
            pointer_fg = xeno.accent_200, -- Pointer color
            statusline_bg = xeno.background_950, -- Statusline background
            statusline_fg = xeno.foreground_100, -- Statusline foreground
            statusline_nc_bg = xeno.background_900, -- Inactive statusline background
            statusline_nc_fg = xeno.foreground_300, -- Inactive statusline foreground
            statusline1_fg = xeno.accent_500, -- Statusline segment 1
            statusline2_fg = xeno.foreground_100, -- Statusline segment 2
            statusline3_fg = xeno.foreground_300, -- Statusline segment 3
        },
        ['hrsh7th/nvim-cmp'] = {
            match_fg = xeno.accent_200, -- Matched text color
            kind_fg = xeno.foreground_100, -- Completion kind color
            menu_fg = xeno.foreground_200, -- Menu text color
            item_fg = xeno.foreground_100, -- Item text color
        },
        ['Saghen/blink.cmp'] = {
            label_fg = xeno.foreground_300, -- Label text color
            match_fg = xeno.accent_300, -- Matched text color
            kind_fg = xeno.foreground_300, -- Kind icon color
            source_fg = xeno.foreground_300, -- Source text color
        },
        ['SmiteshP/nvim-navic'] = {
            text_fg = xeno.foreground_200, -- Text color
            separator_fg = xeno.foreground_200, -- Separator color
            icon_fg = xeno.accent_500, -- Icon color
        },
        ['folke/todo-comments.nvim'] = {
            note_fg = xeno.accent_500, -- NOTE comment color
            warn_fg = xeno.yellow, -- WARN comment color
            fix_fg = xeno.red, -- FIX comment color
            bg = xeno.background_800, -- Background color
        },
        ['nvim-tree/nvim-tree.lua'] = {
            bg = xeno.background_900, -- Background color
            fg = xeno.foreground_100, -- Foreground color
            root_fg = xeno.accent_500, -- Root folder color
            folder_fg = xeno.foreground_100, -- Folder color
            git_add_fg = xeno.green, -- Git added color
            git_modified_fg = xeno.yellow, -- Git modified color
            git_deleted_fg = xeno.red, -- Git deleted color
        },
        ['folke/trouble.nvim'] = {
            bg = xeno.background_950, -- Background color
            fg = xeno.foreground_100, -- Foreground color
        },
        ['folke/snacks.nvim'] = {
            bg = xeno.background_950, -- Base UI background
            fg = xeno.foreground_100, -- Base UI foreground
            border = xeno.background_800, -- Border color

            notifier_info_fg = xeno.blue, -- Info notification color
            notifier_warn_fg = xeno.yellow, -- Warning notification color
            notifier_error_fg = xeno.red, -- Error notification color
            notifier_debug_fg = xeno.purple, -- Debug notification color
            notifier_trace_fg = xeno.foreground_400, -- Trace notification color

            dashboard_bg = xeno.background_950, -- Dashboard background
            dashboard_header_fg = xeno.accent_500, -- Dashboard header color
            dashboard_desc_fg = xeno.foreground_300, -- Dashboard description color
            dashboard_key_fg = xeno.accent_200, -- Dashboard key color

            picker_bg = xeno.background_950, -- Picker background
            picker_match_fg = xeno.accent_200, -- Picker match color
        },
        ['folke/which-key.nvim'] = {
            key_fg = xeno.accent_500, -- Key color
            group_fg = xeno.foreground_300, -- Group color
            bg = xeno.background_900, -- Background color
            border_fg = xeno.background_900, -- Border color
        },
    },
})

require('luna').setup({
    transparent = false,
    accent = 1.0, -- 0-1, blends syntax accents toward grey_light; 1 = full color
    plugins = {
        all = true, -- enable every plugin integration unconditionally
        auto = true, -- when plugins.all is false, autodetect via lazy.nvim
    },
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
})

-- Load scheme

vim.cmd('colorscheme luna')
