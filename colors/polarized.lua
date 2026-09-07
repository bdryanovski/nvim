require('xeno').setup({
    background = '#0a141c',
    accent = '#3ddc97',
    properties = {
        contrast = 0.1,
        variation = 0.1,
        chroma = 0.1,
        lightness = -0.1,
    },
    transparent = false,
    foreground = '#c9dde2',
    _custom_colors = {
        ice = '#8ecae6',
        cyan = '#4fd9e8',
        teal = '#2ec4b6',
        frost = '#a8e6cf',
        aurora = '#3ddc97',
        indigo = '#7c93e0',
        violet = '#9b7fd4',
        glow_pink = '#e39fc2',
    },
    highlights = {
        editor = {
            CursorLine = {
                bg = {
                    __xeno_opaque = true,
                    fg = '@teal.600',
                    opacity = 0.06,
                },
            },
            MatchParen = {
                bold = true,
                fg = '@frost.100',
            },
            IncSearch = {
                bg = {
                    __xeno_opaque = true,
                    fg = '@frost.300',
                    opacity = 0.35,
                },
                fg = '@background.950',
            },
            Visual = {
                bg = {
                    __xeno_opaque = true,
                    fg = '@aurora.500',
                    opacity = 0.18,
                },
            },
            CursorLineNr = {
                bold = true,
                fg = '@frost.100',
            },
            Search = {
                bg = {
                    __xeno_opaque = true,
                    fg = '@cyan.400',
                    opacity = 0.25,
                },
                fg = '@foreground.50',
            },
        },
        syntax = {
            ['@keyword.return'] = {
                link = 'Keyword',
            },
            Type = {
                fg = '@cyan.200',
            },
            Keyword = {
                fg = '@violet.300',
            },
            Variable = {
                fg = '@foreground.300',
            },
            ['@lsp.typemod.property.declaration'] = {
                link = '@property',
            },
            ['@property'] = {
                link = 'Property',
            },
            ['@lsp.mod.declaration'] = {
                clear = true,
            },
            ['@lsp.type.keyword'] = {
                link = '@keyword',
            },
            ['@keyword'] = {
                link = 'Keyword',
            },
            Comment = {
                italic = true,
                fg = '@foreground.400',
            },
            ['@type'] = {
                link = 'Type',
            },
            ['@lsp.type.function'] = {
                link = '@function',
            },
            ['@function'] = {
                link = 'Function',
            },
            ['@lsp.type.property'] = {
                link = '@property',
            },
            ['@lsp.type.variable'] = {
                link = '@variable',
            },
            ['@variable'] = {
                link = 'Variable',
            },
            ['@punctuation.delimiter'] = {
                link = 'Punctuation',
            },
            Boolean = {
                fg = '@frost.100',
            },
            ['@punctuation.bracket'] = {
                link = 'Punctuation',
            },
            Property = {
                fg = '@ice.300',
            },
            ['@operator'] = {
                link = 'Operator',
            },
            ['@constructor'] = {
                fg = '@foreground.400',
            },
            Punctuation = {
                fg = '@foreground.400',
            },
            ['@variable.builtin'] = {
                fg = '@indigo.200',
            },
            ['@keyword.repeat'] = {
                link = 'Conditional',
            },
            ['@constant.builtin'] = {
                bold = true,
                fg = '@glow_pink.100',
            },
            Conditional = {
                fg = '@indigo.300',
            },
            ['@constant'] = {
                fg = '@frost.200',
            },
            ['@lsp.type.type'] = {
                link = '@type',
            },
            ['@boolean'] = {
                link = 'Boolean',
            },
            ['@number'] = {
                link = 'Number',
            },
            ['@string.escape'] = {
                fg = '@ice.100',
            },
            Operator = {
                fg = '@cyan.300',
            },
            ['@string'] = {
                link = 'String',
            },
            ['@function.builtin'] = {
                fg = '@cyan.100',
            },
            Number = {
                fg = '@frost.100',
            },
            ['@keyword.import'] = {
                fg = '@teal.400',
            },
            Function = {
                fg = '@teal.300',
            },
            ['@keyword.operator'] = {
                fg = '@cyan.300',
            },
            ['@punctuation'] = {
                link = 'Punctuation',
            },
            String = {
                fg = '@aurora.100',
            },
            ['@keyword.conditional'] = {
                link = 'Conditional',
            },
            ['@keyword.function'] = {
                link = 'Conditional',
            },
        },
    },
    integrations = {
        ghostty = {
            update_config = false,
            enabled = false,
        },
    },
})
vim.g.colors_name = 'polarized'
