-- monoz config
-- Forked from monoglow.nvim. monoglow includes code derived from tokyonight.nvim,
-- licensed under the Apache License, Version 2.0.

local M = {}

---@class monoz.Config
---@field on_colors? fun(colors: ColorScheme)
---@field on_highlights? fun(highlights: monoz.Highlights, colors: ColorScheme)
M.defaults = {
    glow = true, -- When `true`, some highlights are bold (e.g. Function, Keyword)
    transparent = false, -- When `true`, the background is transparent
    terminal_colors = true, -- Set the colors used for `:terminal`

    --- Colorize individual syntax roles. Each value is either:
    ---   * an accent name from the palette: "red", "orange", "yellow", "green",
    ---     "teal", "cyan", "blue", "purple", "magenta", "pink", "glow"
    ---   * a hex string, e.g. "#ff8800"
    ---   * a palette key, e.g. "blue2", "lack", "gray7"
    ---   * `false` or `nil` to keep the monochrome default
    --- Leave the whole table empty for the original monochrome look.
    syntax = {
        -- keywords
        keyword = false, -- generic keywords
        keyword_return = false, -- return, yield
        keyword_exception = false, -- try, catch, throw, raise
        -- blocks / control flow
        conditional = false, -- if, else, switch, match
        loop = false, -- for, while, loop
        operator = false, -- + - * / and or not (default: glow)
        -- functions
        func_def = false, -- function definitions
        func_call = false, -- function calls
        func_param = false, -- parameters
        builtin = false, -- builtin functions/modules
        -- types
        type = false, -- types
        type_def = false, -- type definitions
        type_primitive = false, -- int, string, bool
        -- data
        string = false, -- string literals
        string_escape = false, -- \n, \t, regex (default: lack)
        number = false, -- numeric literals
        boolean = false, -- true, false (default: blue2)
        const = false, -- constants
        const_builtin = false, -- nil, true, false constants
        -- variables / members
        var = false, -- variables
        var_builtin = false, -- this, self
        var_member = false, -- obj.member
        property = false, -- struct/object properties
        tag = false, -- html/xml tags
        punctuation = false, -- delimiters, brackets
        comment = false, -- comments
    },

    --- Attribute toggles per syntax role (bold, italic, underline).
    --- These mirror catppuccin / koda / kanagawa style tables.
    --- Any valid `:help nvim_set_hl` key works (bold, italic, underline, ...).
    styles = {
        comments = { italic = true },
        keywords = {},
        conditionals = {},
        loops = {},
        functions = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        types = {},
        operators = {},
        properties = {},
    },

    --- Override specific color groups to use other colors or hex values.
    --- Called with the resolved ColorScheme table.
    ---@param colors ColorScheme
    on_colors = function(colors) end,

    --- Override specific highlights. Called with the Highlights and ColorScheme.
    ---@param highlights monoz.Highlights
    ---@param colors ColorScheme
    on_highlights = function(highlights, colors) end,

    plugins = {
        -- Enable all plugin integrations when not using lazy.nvim.
        -- This config uses vim.pack, so `all` defaults to true.
        all = package.loaded.lazy == nil,
        -- Autodetect needed plugins. Only lazy.nvim is supported.
        auto = true,
        -- Add plugins here to force enable/disable, e.g. `telescope = false`.
    },
    lualine_bold = true, -- When `true`, lualine section headers are bold
    eob = false, -- When `true`, the end-of-buffer line is visible
}

---@type monoz.Config
M.options = nil

---@param options? monoz.Config
function M.setup(options)
    M.options = vim.tbl_deep_extend('force', {}, M.defaults, options or {})
end

---@param opts? monoz.Config
function M.extend(opts)
    return opts and vim.tbl_deep_extend('force', {}, M.options, opts) or M.options
end

setmetatable(M, {
    __index = function(_, k)
        if k == 'options' then
            return M.defaults
        end
    end,
})

return M
