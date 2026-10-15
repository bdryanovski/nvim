# monoz

A personal Neovim colorscheme. It is a fork of
[monoglow.nvim](https://github.com/wnkz/monoglow.nvim) `z` style. monoglow
includes code derived from tokyonight.nvim, licensed under the Apache License,
Version 2.0.

The base look is monochrome. A grayscale ramp carries most of the UI and syntax.
One green accent (`glow`) marks active state. On top of that base you can color
and style each syntax role on its own. This lets you start from a calm
monochrome editor and add exactly the color you want, where you want it.

## Install

monoz lives inside this config, so there is nothing to clone. The module path is
`bdryanovski.monoz`. The color entry point is `colors/monoz.lua`. The matching
lualine theme is `lua/lualine/themes/monoz.lua`.

To activate it, set up the options and load the scheme. `plugin/themes.lua`
already does this:

```lua
require('bdryanovski.monoz').setup({ --[[ options ]] })
vim.cmd('colorscheme monoz')
```

Call `setup` before `colorscheme`. `setup` stores your options. `colorscheme`
reads them and applies the highlights.

For lualine, set the theme name to `monoz`:

```lua
require('lualine').setup({ options = { theme = 'monoz' } })
```

## Configure

Pass options to `setup`. All options are optional. The defaults produce the
monochrome look.

```lua
require('bdryanovski.monoz').setup({
    glow = true, -- bold on Function, Keyword, and Operator
    transparent = false, -- transparent background
    terminal_colors = true, -- set the `:terminal` ANSI palette
    lualine_bold = true, -- bold lualine section headers
    eob = false, -- show the end-of-buffer `~` lines

    syntax = { --[[ per-role colors, see below ]] },
    styles = { --[[ per-role attributes, see below ]] },

    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,

    plugins = { all = true, auto = true },
})
```

### syntax: color a role

The `syntax` table maps a syntax role to a color. Each value is one of:

- an accent name: `red`, `orange`, `yellow`, `green`, `teal`, `cyan`, `blue`,
  `purple`, `magenta`, `pink`, `glow`
- a palette key: for example `blue2`, `lack`, `gray7`, `luster`
- a hex string: for example `"#ff8800"`
- `false` to keep the monochrome default

```lua
syntax = {
    keyword = 'purple', -- if, const, func, import, ...
    conditional = 'orange', -- if, else, switch, match
    loop = 'orange', -- for, while, loop
    keyword_return = 'pink', -- return, yield
    keyword_exception = 'red', -- try, catch, throw, raise
    func_def = 'blue', -- function definitions
    func_call = false, -- function calls
    func_param = 'yellow', -- parameters
    builtin = 'cyan', -- builtin functions and modules
    type = 'teal', -- types
    type_def = 'teal', -- type definitions
    type_primitive = 'teal', -- int, string, bool
    string = 'green', -- string literals
    string_escape = 'cyan', -- \n, \t, regex
    number = 'magenta', -- numeric literals
    boolean = 'magenta', -- true, false
    const = 'yellow', -- constants
    const_builtin = 'yellow', -- nil, true, false constants
    var = false, -- variables
    var_builtin = 'red', -- this, self
    var_member = false, -- obj.member
    property = 'blue', -- struct and object properties
    tag = 'green', -- html and xml tags
    punctuation = false, -- delimiters and brackets
    comment = false, -- comments
}
```

The full list of role keys is in `config.lua`.

### styles: set attributes on a role

The `styles` table sets attributes per role. Each value is a table of
`:help nvim_set_hl` keys, for example `bold`, `italic`, `underline`,
`undercurl`, `strikethrough`.

```lua
styles = {
    comments = { italic = true },
    keywords = { bold = true },
    conditionals = {},
    loops = {},
    functions = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    types = { italic = true },
    operators = {},
    properties = {},
}
```

## How it works

monoz builds the highlights in four stages. Each stage is a small module.

1. `palette.lua` defines the raw colors. It holds the grayscale ramp
   (`gray1`..`gray10`), the background and foreground, the `glow` accent, the git
   colors, and the named `accents` table.
2. `colors.lua` turns the palette into a semantic `ColorScheme`. It derives the
   UI backgrounds, the cursor and selection colors, the diagnostics, the
   terminal palette, and the `syntax` color table. After it builds the
   monochrome defaults, it applies your `syntax` overrides. It then calls
   `on_colors`.
3. `groups/` maps the semantic colors to highlight groups. `groups/base.lua`
   covers the editor and the core syntax groups. `groups/treesitter.lua` and
   `groups/semantics_token.lua` cover treesitter and LSP tokens. Each file under
   `groups/` adds one plugin. `groups/init.lua` merges them and calls
   `on_highlights`.
4. `theme.lua` applies every group with `nvim_api_set_hl`, sets
   `vim.g.colors_name`, and sets the terminal colors.

The data flows one way: palette, then colors, then groups, then apply. To change
a color in one place, change it in the stage that owns it.

## How to extend

### Add a new accent color

Edit `palette.lua`. Add a key to the `accents` table:

```lua
accents = {
    -- ...
    sky = '#8ab4f8',
}
```

You can now use `'sky'` as a value in the `syntax` config.

### Color a role that is not exposed yet

The `syntax` config covers the common roles. For a role it does not expose, use
`on_highlights`. This hook runs last and can set any group:

```lua
on_highlights = function(hl, c)
    hl['@keyword.import'] = { fg = c.accents.cyan }
    hl.Comment = { fg = c.accents.teal, italic = true }
end,
```

`c` is the full `ColorScheme`. It gives you `c.accents`, `c.syntax`, the
grayscale ramp, and every derived UI color.

### Change a derived color

Use `on_colors` to change a color before the groups read it. This affects every
group that uses it:

```lua
on_colors = function(colors)
    colors.glow = '#ff6ac1' -- change the active accent everywhere
    colors.border = colors.gray5
end,
```

### Add a plugin integration

1. Create `groups/<plugin>.lua`. Return a module with `M.url` and
   `M.get(c, opts)`. `M.get` returns a table of highlight groups.

   ```lua
   local M = {}
   M.url = 'https://github.com/author/my-plugin.nvim'

   ---@type monoz.HighlightsFn
   function M.get(c, opts)
       return {
           MyPluginTitle = { fg = c.title, bold = true },
           MyPluginBorder = { fg = c.border, bg = c.bg_popup },
       }
   end

   return M
   ```

2. Register it in `groups/init.lua`. Add an entry to `M.plugins`. The key is the
   plugin name. The value is the group file name without `.lua`:

   ```lua
   M.plugins = {
       -- ...
       ['my-plugin.nvim'] = 'my-plugin',
   }
   ```

This config uses `vim.pack`, so `plugins.all` is `true` by default and every
plugin group loads. To force a plugin off, set `plugins['my-plugin'] = false`
in `setup`.

### Reuse the LSP kind icons

Some plugins show LSP kind icons, for example completion menus and breadcrumbs.
`groups/kinds.lua` builds a consistent set. Call it with a pattern to generate
the plugin prefix:

```lua
require('bdryanovski.monoz.groups.kinds').kinds(ret, 'MyPluginKind%s')
```

See `groups/blink-cmp.lua` and `groups/barbecue.lua` for working examples.

## Files

| Path | Role |
| --- | --- |
| `palette.lua` | Raw colors and the named accent set |
| `config.lua` | Default options and option merge |
| `colors.lua` | Palette to semantic `ColorScheme`, applies `syntax` |
| `groups/init.lua` | Plugin map and highlight merge |
| `groups/base.lua` | Editor and core syntax groups |
| `groups/treesitter.lua` | Treesitter capture groups |
| `groups/semantics_token.lua` | LSP semantic token groups |
| `groups/kinds.lua` | Shared LSP kind icons |
| `groups/<plugin>.lua` | One file per plugin integration |
| `theme.lua` | Applies groups and terminal colors |
| `types.lua` | lua-ls type annotations |
| `util.lua`, `hsluv.lua` | Color math helpers |

The color entry point `colors/monoz.lua` and the lualine theme
`lua/lualine/themes/monoz.lua` live at the config root so Neovim can find them.
