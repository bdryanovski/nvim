# Core Neovim Options

This document explains the core Neovim options configured in this setup, with
short descriptions and the most relevant alternative values.

The focus is on native `vim.opt`/`vim.g` settings (not plugin-specific
configuration).

---

## 1. Global Variables (`vim.g`)

### Project roots

Defined in `init.lua`:

```lua
vim.g.projects_dir = vim.env.HOME .. "/Projects"
vim.g.github_projects_dir = vim.env.HOME .. "/Github"
vim.g.work_projects_dir = vim.env.HOME .. "/Manual"
```

Used by the custom navbar plugin to group projects by location (e.g. CODE,
GITHUB, MANUAL). You can point these to any directories you like.

### Leader key

Defined in `lua/bdryanovski/base/mapping.lua`:

```lua
vim.g.mapleader = ","
```

Sets `<leader>` to `,`. All mappings that use `<leader>` expand to this key.
Common alternatives: space (`" "`) or backslash (`"\\"`).

### Neovide globals

Defined in `lua/bdryanovski/neovide/init.lua` if `vim.g.neovide` is set
(Neovide GUI only):

```lua
g.neovide_text_gamma = 0.0
g.neovide_text_contrast = 0.5

g.neovide_padding_top = 0
g.neovide_padding_bottom = 0
g.neovide_padding_right = 0
g.neovide_padding_left = 0

g.neovide_scroll_animation_length = 0.2
g.neovide_scroll_animation_far_lines = 1
g.neovide_hide_mouse_when_typing = false
g.neovide_refresh_rate = 60
g.neovide_refresh_rate_idle = 5
g.neovide_profiler = false
g.neovide_cursor_trail_size = 0.8
g.neovide_cursor_antialiasing = true
g.neovide_cursor_vfx_mode = "ripple"
g.neovide_fullscreen = false
```

These control Neovide-specific behavior: padding, scroll animation, refresh
rates, cursor effects, etc. They have no effect in terminal Neovim.

---

## 2. UI & Appearance

### True color

```lua
vim.opt.termguicolors = true
```

Enables 24‑bit RGB color support. This is required for modern colourschemes to
render correctly.

- `true`: use full 24‑bit color (recommended).
- `false`: use 16‑color terminal palette only.

### Statusline (`laststatus`)

```lua
vim.opt.laststatus = 3
```

Controls when the statusline is shown:

- `0` – never.
- `1` – only if there are at least two windows.
- `2` – always (per window).
- `3` – **global statusline** (Neovim >= 0.7). This config uses `3`.

### Line numbers

```lua
vim.opt.number = true
vim.opt.relativenumber = true
```

- `number = true` – show absolute line number on the current line.
- `relativenumber = true` – show relative line numbers elsewhere.

Together, this gives hybrid line numbers: useful for motions like `5j` or
`3k` as you can see distances to the cursor.

### Cursor line

```lua
vim.opt.cursorline = true
```

Highlights the line the cursor is on. Set to `false` to disable.

### Background

```lua
vim.opt.background = "dark"
```

Hints to colourschemes that you use a dark terminal background. Supported
values: `"dark"` or `"light"`.

### Color column

```lua
vim.opt.colorcolumn = "100"
```

Draws a vertical guideline at column 100. Common alternatives: `"80"`, or
`""` to disable the column.

### Matching brackets

```lua
vim.opt.showmatch = true
```

Briefly highlights the matching bracket when the cursor moves over one.

### Sign column

```lua
vim.opt.signcolumn = "yes"
```

Controls the column where signs (diagnostics, git markers, etc.) appear.

- `"no"` – never show.
- `"yes"` – always show (used here, avoids text shifting).
- `"auto"`, `"auto:<n>"` – automatically show when needed.

### Window minimum width

```lua
vim.opt.winminwidth = 5
```

Minimum width in columns for a window. Prevents windows from being shrunk too
narrow when splitting.

### Window borders

```lua
vim.opt.winborder = "rounded"
```

Controls the default border style for floating windows.

Common values: `"none"`, `"single"`, `"double"`, `"rounded"`, `"solid"`,
`"shadow"`.

### Fill characters

```lua
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
```

Controls characters used for various UI fillers:

- `foldopen`, `foldclose`, `fold`, `foldsep` – visuals in the fold column.
- `diff` – filler in diff mode.
- `eob` – character used for "end of buffer" lines. Set to space to hide the
  default `~` glyphs.

Peacock (`lua/bdryanovski/custom/peacock`) may append `eob = "█"` to this to
show a colored bar for the leftmost window.

### GUI cursor (`guicursor`)

Set in `init.lua`:

```lua
vim.opt.guicursor =
  "n-v-c-sm:block-nCursor-blinkwait300-blinkon200-blinkoff150," ..
  "i-ci-ve:ver100,r-cr-o:hor20"
```

Controls the cursor shape and blinking in different modes. The general format
is `mode-list:shape[-hlgroup][-blinkopts]`.

- `n-v-c-sm:block-...` – normal/visual/command/smode use a blinking block
  cursor with the `nCursor` highlight.
- `i-ci-ve:ver100` – insert/command-insert/visual-ex use a vertical bar.
- `r-cr-o:hor20` – replace/command-replace/operator-pending use a horizontal
  bar.

### GUI font (`guifont`, Neovide)

```lua
vim.opt.guifont = "Iosevka Custom Light Extended:h13"
```

Font for GUI clients (Neovide). Change the string to any installed font, e.g.
`"FiraCode Nerd Font:h13"`.

---

## 3. Editing & Text

### Spell checking

```lua
vim.opt.spelllang = { "en" }
```

Sets languages used for spell checking. Additional FileType autocommands enable
spell check for `gitcommit`, `markdown`, and `mdx` filetypes:

```lua
vim.opt_local.textwidth = 100
vim.opt_local.wrap = false
vim.opt_local.spell = true
```

### Indentation and tabs

```lua
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
```

- `tabstop` – visual width of a literal `<Tab>` character.
- `shiftwidth` – amount of indentation used by commands like `>>`, `<<`, `=`.
- `expandtab` – insert spaces instead of literal tabs when indenting.
- `autoindent` – copy indent from the current line when starting a new line.
- `smartindent` – C-like indentation helpers (add/remove indent around braces,
  etc.).

To switch to 4-space indentation, set `tabstop = 4`, `shiftwidth = 4`.

### Wrapping

```lua
vim.opt.wrap = false
```

Disables line wrapping; long lines extend past the right edge. Use
`vim.opt.wrap = true` (optionally combined with `linebreak` and `breakindent`)
for soft-wrapped text.

### Backspace behavior

```lua
vim.opt.backspace = { "indent", "eol", "start" }
```

Controls where Backspace works in insert mode:

- `indent` – can delete auto-indent.
- `eol` – can delete past end-of-line.
- `start` – can delete before where insert mode started.

This is the "modern" behavior most people expect.

### Selection

```lua
vim.opt.selection = "inclusive"
```

Controls how the last character in a visual selection is treated:

- `"inclusive"` – last character is included.
- `"exclusive"` – last character is excluded.
- `"old"` – legacy behavior.

### Keywords (`iskeyword`)

```lua
vim.opt.iskeyword:append("-")
```

Adds `-` to the definition of a "word". Motions like `w`, `b`, and `*` treat
`string-string` as a single word instead of two.

---

## 4. Search & Grep

### Case handling

```lua
vim.opt.ignorecase = true
vim.opt.smartcase = true
```

- `ignorecase = true` – case-insensitive search by default.
- `smartcase = true` – if the pattern contains uppercase letters, search becomes
  case-sensitive.

So `/foo` matches `foo` and `Foo`, but `/Foo` matches only `Foo`.

### Grep program

```lua
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
```

Uses ripgrep (`rg`) as the backend for `:grep`. `--vimgrep` makes `rg` output
`file:line:column:message` format, and `grepformat` tells Neovim how to parse
that.

---

## 5. Windows, Splits & Scrolling

### Split behavior

```lua
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
```

- `splitright = true` – vertical splits open to the right.
- `splitbelow = true` – horizontal splits open below.
- `splitkeep = "screen"` – attempts to keep the visible text stable when
  opening/closing splits.

Other `splitkeep` values include `"cursor"` and `"topline"`.

### Scroll offsets

```lua
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
```

- `scrolloff` – keep at least N lines visible above/below the cursor.
- `sidescrolloff` – keep at least N columns visible to the left/right.

### Smooth scroll (Neovim >= 0.10)

```lua
if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
end
```

Enables the built-in smooth scrolling behavior when supported.

---

## 6. Files, Encoding, Undo & Swap

### Encodings

```lua
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
```

- `scriptencoding` – encoding of your configuration files.
- `encoding` – Neovim's internal encoding.
- `fileencoding` – default encoding for files.

Setting all of these to UTF‑8 is standard for modern setups.

### Swap and undo

```lua
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
```

- `swapfile = false` – disables swapfiles. You lose some crash-recovery, but
  avoid "swap already exists" prompts.
- `undofile = true` – enables persistent undo to disk.
- `undolevels = 10000` – maximum number of undo steps.

### Auto-read

```lua
vim.opt.autoread = true
```

Together with this autocommand:

```lua
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
```

Neovim will automatically detect when a file has changed on disk and prompt to
reload or just reload it (depending on context).

### Confirm dialogs

```lua
vim.opt.confirm = true
```

Instead of failing, operations that would discard changes (e.g. `:quit` with
unsaved buffers) will prompt for confirmation.

---

## 7. Folding

```lua
vim.opt.foldlevel = 4
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
```

- `foldmethod = "expr"` – folding is determined by an expression.
- `foldexpr = "nvim_treesitter#foldexpr()"` – use the Treesitter-based
  folding expression.
- `foldlevel = 4` – folds deeper than level 4 start in a closed state; shallower
  folds are open.

Other common `foldmethod` values: `"indent"`, `"marker"`, `"syntax"`.

---

## 8. Timings & Performance

### Redraw behavior

```lua
vim.opt.lazyredraw = false
```

When `true`, Neovim avoids redrawing during macros/commands, improving
performance at the cost of responsiveness. You keep it `false` due to some
UI/plugin behavior.

### Mapping timeout (`timeoutlen`)

```lua
vim.opt.timeoutlen = 300
```

Time in milliseconds Neovim waits for a mapped sequence to complete.
Smaller values make keymaps feel snappier but require faster input.

### CursorHold & swap timing (`updatetime`)

`updatetime` is set in several places (`base/init.lua`, `core/lsp.lua`,
`plugin/barbecue.nvim.lua`). After everything loads, the effective setting is:

```lua
vim.opt.updatetime = 200
```

Controls:

- How often swapfiles are written.
- Delay before `CursorHold` is triggered (used by diagnostics, plugins like
  `barbecue.nvim`, etc.).

Typical values: `200`–`1000` ms.

---

## 9. Clipboard

```lua
vim.opt.clipboard:append("unnamedplus")
```

Adds `unnamedplus` to the `clipboard` option so the default register syncs
with the system clipboard (on platforms that support the `+` register).

Other variants:

- `"unnamed"` – sync with primary selection (`*`).
- `"unnamed,unnamedplus"` – both.

---

## 10. Runtime Path & Dimensions

### Runtime path (`rtp`)

- `lazy.lua` prepends the path to `lazy.nvim` to `vim.opt.rtp` when using
  that plugin manager.
- `lua/bdryanovski/pack.lua` similarly prepends directories for local
  plugins.

`rtp` is the list of directories Neovim searches for runtime files
(colorschemes, plugins, ftplugins, etc.).

### Screen dimensions

Used in `plugin/tree.lua`:

```lua
vim.opt.columns:get()
vim.opt.lines:get()
vim.opt.cmdheight:get()
```

These give the current terminal width, total lines, and command-line height,
used to size and center the floating file tree window.

---

## 11. Filetype-Local Options

From `lua/bdryanovski/base/autocmd.lua`:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "mdx" },
  callback = function()
    vim.opt_local.textwidth = 100
    vim.opt_local.wrap = false
    vim.opt_local.spell = true
  end,
})
```

For these filetypes:

- `textwidth = 100` – target line width for formatting.
- `wrap = false` – keep long lines unwrapped.
- `spell = true` – enable spell checking.

---

## 12. Miscellaneous

### Lua module loader

```lua
if vim.loader then
  vim.loader.enable()
end
```

Enables Neovim's built-in Lua module loader, which caches compiled bytecode
and improves startup time.

---

This document focuses on core Neovim options. Plugin-specific configuration
(e.g. completion, LSP, treesitter, etc.) is documented in the individual
plugin config files under `plugin/` and `lua/bdryanovski/`.
