# Configuration Files Overview

This document explains the purpose of the main configuration files in this
Neovim setup and how they fit together. It complements
[`docs/options.md`](options.md), which focuses on individual `vim.opt`/`vim.g`
settings.

Paths are relative to `~/.config/nvim`.

---

## 1. Entry Point: `init.lua`

**File:** `init.lua`

Responsibilities:

- Enable Neovim's experimental Lua module loader (`vim.loader.enable()`)
  for faster startup.
- Ensure truecolor is enabled (`termguicolors`).
- Define global project directory variables:
  - `vim.g.projects_dir` → `~/Projects`
  - `vim.g.github_projects_dir` → `~/Github`
  - `vim.g.work_projects_dir` → `~/Manual`
- Load core modules:
  - `require("bdryanovski.base")` – core options.
  - `require("bdryanovski.base.autocmd")` – global autocommands.
  - `require("bdryanovski.base.mapping")` – core keymaps.
  - `require("bdryanovski.core.lsp")` – LSP configuration.
  - `require("bdryanovski.neovide")` – GUI-specific settings (if Neovide).
- Define a `PackChanged` autocommand to build `blink.cmp` with Cargo whenever
  that plugin is installed or updated by `vim.pack`.
- Configure a custom `guicursor` string to control cursor shapes and blinking
  in different modes.

In short: `init.lua` wires together your base settings, LSP, GUI tweaks, and
plugin build step.

---

## 2. Core Base Layer: `lua/bdryanovski/base/`

### 2.1 Options – `lua/bdryanovski/base/init.lua`

Defines essentially all core `vim.opt` settings:

- UI: line numbers, statusline mode, cursorline, colorcolumn, signcolumn,
  background, window borders, fill characters, etc.
- Editing: indentation settings, wrap, backspace behavior, spell language,
  selection, `iskeyword` modifications.
- Search: `ignorecase`, `smartcase`, `grepprg`/`grepformat` using ripgrep.
- Windows: split behavior (`splitright`, `splitbelow`, `splitkeep`), scroll
  offsets, minimum window width.
- Files: encodings (`utf-8`), swapfile disabled, persistent undo enabled,
  high undo levels.
- Folding: Treesitter-based folding (`foldmethod = "expr"`, `foldexpr` set
  to `nvim_treesitter#foldexpr()`), initial `foldlevel`.
- Timings: `timeoutlen`, `updatetime` (for swap/CursorHold), optional
  `smoothscroll` on Neovim 0.10+.
- Clipboard: adds `unnamedplus` to use the system clipboard.

These options are documented in detail in [`docs/options.md`](options.md).

### 2.2 Autocommands – `lua/bdryanovski/base/autocmd.lua`

Defines global autocommands and a helper:

- `augroup(name)` – convenience function to create namespaced augroups with
  `bdryanovski_` prefix.
- Highlight on yank – uses `TextYankPost` to briefly highlight yanked text.
- Resize splits on `VimResized` – equalizes windows across all tabs while
  preserving the current tab.
- Restore last cursor location on `BufReadPost` – jumps to the last known
  position in a file when reopening.
- Text file tweaks – for `gitcommit`, `markdown`, `mdx`:
  - `textwidth = 100`, `wrap = false`, `spell = true`.
- Auto create directories on `BufWritePre` – ensures parent directories exist
  before writing a new file.
- Auto-read changed files – sets `autoread = true` and triggers `checktime`
  on `BufEnter`, `CursorHold`, `CursorHoldI`, and `FocusGained` (outside of
  command-line mode) to reload files changed on disk.

### 2.3 Keymaps – `lua/bdryanovski/base/mapping.lua`

Defines your core keybindings and leader key:

- `vim.g.mapleader = ","` – leader key.
- General mappings:
  - `<leader>nh` – clear search highlights.
  - `+` / `-` – increment/decrement number under cursor.
  - `<C-a>` – select entire buffer.
  - `H` – jump to first non-blank character.
  - `<C-s>` (in `i/x/n/s` modes) – save file.
- Visual move mappings:
  - `K` / `J` in visual mode – move selected block up/down.
- Tabs:
  - `<leader>te` – new tab.
  - `<Tab>` / `<S-Tab>` – next/previous tab.
  - `<C-w>` – close current tab.
  - `<C-to>` – close all other tabs.
- Windows:
  - `<Space>` – cycle to next window.
  - `s<left/right/up/down>` – move focus between windows.
  - `ss` / `sv` – horizontal/vertical split.
  - `<C-Up/Down/Left/Right>` – resize window.
- Commands:
  - `:Q`, `:W`, `:WQ` – user commands mapping to `:q`, `:w`, `:wq`.
  - `<leader>qq` – quit all.
- Diagnostics:
  - `<C-j>` – jump to next diagnostic.
- Hardmode:
  - Disables arrow keys in normal/visual modes (`<Up/Down/Left/Right>`).

---

## 3. LSP Core: `lua/bdryanovski/core/lsp.lua`

Responsibilities:

- Enable and register LSP servers via `vim.lsp.enable()`:
  - `lua_ls`, `ts_ls`, `cssls`, `html`, `astro_ls`, `biome`, `rust_analyzer`,
    `gopls`, `intelephense`, `phpactor`, `clangd`, `oxfmt`, `oxlint`.
- Configure global diagnostics:
  - Underlines, virtual text disabled by default, floating windows with
    rounded borders and source shown, custom sign icons and `numhl`.
- Adjust floating window highlights:
  - Links `NormalFloat` to `Normal` and sets `FloatBorder` background to
    transparent; reapplied on `ColorScheme` events.
- `LspAttach` autocommand:
  - Sets buffer-local LSP keymaps:
    - `K` – hover.
    - `<C-k>` – signature help.
    - `<leader>d` – show line diagnostics.
    - `gK` – toggle diagnostics `virtual_lines`.
  - Adds document highlight autocommands when the server supports
    `textDocument/documentHighlight`:
    - Highlights references on `CursorHold`/`CursorHoldI`.
    - Clears highlights on `CursorMoved`/`CursorMovedI` and `LspDetach`.
  - Adds inlay hints toggle (`<leader>th`) when supported by the server.
- Sets `vim.opt.updatetime = 1000` (later overridden to `200` in a plugin,
  but this file expresses the LSP's preference).

The file is the central place for builtin LSP behavior and per-buffer
attachments.

---

## 4. Neovide Integration: `lua/bdryanovski/neovide/init.lua`

Only executed when running under Neovide (`vim.g.neovide` is set).

Responsibilities:

- Configure Neovide-specific globals:
  - Text gamma/contrast, padding, scroll animation, refresh rate, cursor trail,
    cursor VFX, fullscreen toggle.
- Set GUI font via `vim.opt.guifont`.
- Configure blur, scale factor, and mapping for zooming:
  - `<C-=>` – increase scale (`neovide_scale_factor`).
  - `<C-->` – decrease scale.

This file contains **no** terminal-specific settings; it only tunes the GUI.

---

## 5. Plugin Management: `lua/bdryanovski/pack.lua`

**File:** `lua/bdryanovski/pack.lua`

A thin wrapper around Neovim's builtin `vim.pack` that adds lazy loading
capabilities.

Key features:

- Exports `M.add(specs)`:
  - Accepts either:
    - A list of specs (strings or tables), or
    - A single spec table with `src` or `dir`.
- Spec fields:
  - `src` – Git URL (remote plugin).
  - `dir` – local directory (local plugin).
  - `name` – override plugin name.
  - `version` – version constraint.
  - `event` – autocommand event(s) that trigger loading, e.g. `"InsertEnter"`
    or `"BufReadPost"`.
  - `ft` – filetype(s) that trigger loading.
  - `config` – function run after plugin is loaded.
  - `enabled` – `false` to disable.
- Behavior:
  - Specs without `event`/`ft` are passed to `vim.pack.add` and loaded eagerly.
  - Specs with `event`/`ft` are installed but not loaded; `Pack` augroup
    autocommands are set up to load them on first trigger.
  - Local plugins (`dir`) are loaded by prepending to `runtimepath` and
    sourcing any `plugin/` and `ftdetect/` scripts inside.
  - A synthetic `VeryLazy` event maps to `UIEnter` + `vim.schedule()` to match
    lazy.nvim conventions.

This module is used in several `plugin/custom.*.lua` files and can be reused
for additional lazy-loaded plugins.

> Note: There is also `lua/bdryanovski/lazy.lua`, which sets up
> `folke/lazy.nvim`. The current entrypoint (`init.lua`) uses `vim.pack`
> and the `plugin/` directory instead; `lazy.lua` is kept as an alternate or
> legacy setup.

---

## 6. Custom Local Plugins: `lua/bdryanovski/custom/`

### 6.1 Bookmarks – `custom/bookmarks` + `plugin/custom.bookmarks.lua`

- Local plugin implementing simple line bookmarks:
  - Signs with configurable text/highlight (default 🔖, overridden to 📍).
  - Persistent storage in `stdpath('data')/bookmarks.json`.
  - Autoload bookmarks for a file on `BufReadPost`.
- Default keymaps (configurable):
  - `mb` – toggle bookmark on current line.
  - `]b` / `[b` – next/previous bookmark.
  - `<leader>bl` – list bookmarks.
- User commands:
  - `:BookmarkNext`, `:BookmarkPrev`, `:BookmarkList`,
    `:BookmarkClear`, `:BookmarkClearAll`.

Configured in `plugin/custom.bookmarks.lua`.

### 6.2 Navbar – `custom/navbar` + `plugin/custom.navbar.lua`

- Provides a `render()` function that builds a **winbar** string showing the
  current file path in a breadcrumb-like style.
- Uses special prefixes for known roots (e.g. `CODE`, `GITHUB`, `MANUAL`)
  based on `vim.g.projects_dir`, `vim.g.github_projects_dir`, etc.
- Shortens the path when the window is too narrow.
- Autocmd in `plugin/custom.navbar.lua` attaches the winbar on `BufWinEnter`
  for normal, non-floating, non-diff windows with an associated file.

### 6.3 Peacock – `custom/peacock` + `plugin/custom.peacock.lua`

- Assigns a constant color per project directory based on the current working
  directory.
- Highlights specific UI elements in that color:
  - Sign column and end-of-buffer in the **leftmost window**.
  - Optionally sets `fillchars.eob = "█"` to create a solid-color bar.
- Autoupdates on window and buffer events.
- `plugin/custom.peacock.lua` configures:
  - `bar_enabled = false` (disables the left-bar signcolumn effect).
  - `sign_column_width = 1`.
  - `eob_enabled = true`.
  - Links `WinSeparator`, `FloatBorder`, and `LineNr` to `PeacockFg`.

### 6.4 Indent – `custom/indent` + `plugin/custom.indent.lua`

- Local plugin inspired by `mini.indentscope`:
  - Draws animated indent scope indicators using a custom `symbol` (`"┊"`).
  - Provides text objects and motions:
    - `ii` / `ai` – inner scope / scope with border.
    - `[i` / `]i` – jump to top/bottom of current scope.
  - Options to control animation delay, number of lines to inspect, border
    behavior, etc.
- Loaded lazily via `Pack` on `BufReadPost` using `plugin/custom.indent.lua`.

### 6.5 Togglewords – `custom/togglewords` + `plugin/custom.togglewords.lua`

- Provides a `toggle_word()` function:
  - Looks at the word under the cursor and replaces it with its pair (e.g.
    `true ↔ false`, `on ↔ off`, `start ↔ stop`, `pick ↔ squash`, etc.).
- Configurable pairs and keymap.
- `plugin/custom.togglewords.lua` configures:
  - `pairs` – subset of the defaults (common toggles).
  - `keymap = "<leader>x"` – toggles the word under the cursor.

---

## 7. Plugin Configs: `plugin/*.lua`

Each file in `plugin/` is auto-sourced by Neovim and typically does two
things:

1. Registers the plugin with `vim.pack.add({ ... })`.
2. Applies configuration by calling the plugin's `setup()` function and/or
   defining related keymaps/autocommands.

Highlights:

- **Core dependencies**
  - `plugin/00-dependencies.lua` – adds `plenary.nvim`.
  - `plugin/01-mini.lua` – adds `mini.icons` and `mini.pairs`, and configures
    autopairs behavior.

- **Completion**
  - `plugin/blink.cmp.lua` – registers `saghen/blink.cmp`, `friendly-snippets`,
    `nvim-lsp-file-operations`, and `blink-cmp-git`. Configures:
    - Keymaps (`<CR>` accepts or falls back).
    - Signature help popup, documentation window, completion menu layout.
    - Ghost text, fuzzy matching backend, snippet integration.
    - Default completion sources per filetype.
    - Global LSP capabilities (via `vim.lsp.config("*", { capabilities = ... })`).

- **Fuzzy finder**
  - `plugin/fzf-lua.lua` – registers `ibhagwan/fzf-lua`, configures UI
    options (layout, borders, preview settings, keymaps) and sets up keybindings
    for files, buffers, grep, LSP queries, diagnostics, and Git commands.

- **Formatting**
  - `plugin/conform.nvim.lua` – registers `stevearc/conform.nvim`, defines
    per-filetype formatters (prettier, oxfmt, stylua, gofmt, etc.), implements
    a `first()` helper to prefer available formatters, sets up format-on-save,
    and user commands `:FormatDisable`, `:FormatEnable`.

- **Syntax & LSP tooling**
  - `plugin/treesitter.lua` – registers:
    - `nvim-treesitter`, `nvim-treesitter-textobjects`,
      `nvim-treesitter-context`, `nvim-lspconfig`, `mason.nvim`.
    - Configures mason with custom icons and ensures a list of language servers
      and tools are installed (typescript-language-server, lua-language-server,
      prettier, stylua, gopls, rust-analyzer, etc.).
    - Calls `require("nvim-treesitter").setup()` and configures
      `treesitter-context`.
    - Adds `mdx` extension/filetype and maps it to the `markdown` parser.
    - Ensures Treesitter highlighting/indentation is started for all
      filetypes via a `FileType` autocommand.

- **UI & theme**
  - `plugin/themes.lua` – registers multiple themes:
    `rose-pine`, `monoglow`, `koda`, `kanagawa`, `catppuccin`, `vague`.
    Configures each theme, then runs `:colorscheme rose-pine` as the active
    scheme.
  - `plugin/lualine.nvim.lua` – configures `lualine.nvim` with an
    abbreviated mode indicator, separators, and minimal sections.
  - `plugin/barbecue.nvim.lua` – sets up `barbecue.nvim` + `nvim-navic` for
    a breadcrumb winbar; uses `CursorHold` and related events to update.
  - `plugin/snacks.nvim.lua` – configures `snacks.nvim` with:
    - Smooth scrolling (terminal buffers only).
    - Dashboard with custom ASCII art header and quick keys.
    - Dim plugin configuration (currently not globally toggled).

- **Navigation & files**
  - `plugin/tree.lua` – registers and configures `nvim-tree.nvim`:
    - Floating, centered file explorer with custom width/height ratios.
    - Icons, indent markers, git integration, and keymaps under `<leader>t`/
      `<leader>ef`/`<leader>ec`/`<leader>er`.

- **Git & diagnostics**
  - `plugin/gitsigns.nvim.lua` – (not shown here, but present) configures
    git gutter signs and hunk actions.
  - `plugin/todo-comments.lua`, `plugin/vim-illuminate.lua`,
    `plugin/tiny-inline-diagnostic.lua`, `plugin/better-type-hover.lua` –
    various diagnostics/UX enhancements.

- **Miscellaneous**
  - `plugin/noice.lua` – overrides cmdline, messages, and notifications.
  - `plugin/nvim-colorizer.lua` – colorizes color codes in buffers.
  - `plugin/nvim-ts-autotag.lua` – autopairs tags in markup languages.
  - `plugin/copilot.lua` – GitHub Copilot integration.
  - `plugin/namu.lua`, `plugin/grug-far.lua`, `plugin/fluoride.lua`,
    `plugin/lazydev.nvim.lua`, `plugin/comment.nvim.lua`, `plugin/incline.lua`,
    etc. – additional plugins with their own small setup blocks.

For details, open each `plugin/*.lua` file directly – most follow the pattern:

```lua
vim.pack.add({ "https://github.com/owner/repo" })
require("plugin-module").setup({ ... })
```

---

## 8. LSP Server-Specific Configs: `lsp/`

The `lsp/` directory (not fully shown above) is intended for per-server
configuration used by `vim.lsp.config`. For example, you might have:

- `lsp/lua_ls.lua` – Lua language server settings.
- `lsp/ts_ls.lua` – TypeScript/JavaScript server tweaks.
- `lsp/biome.lua` – Biome-specific behavior.

Each file typically calls `vim.lsp.config("server-name", { ... })` to extend
or override defaults defined in `core/lsp.lua` and `plugin/blink.cmp.lua`.

---

## 9. Snippets: `snippets/`

Directory for any custom snippet files (LuaSnip, etc.). The specific format
and loader depend on your snippet engine (see `plugin/luasnip.lua` or similar
if present).

---

This overview is meant as a map of "what lives where" in your Neovim
configuration. For detailed explanations of individual options, see
[`docs/options.md`](options.md); for plugin behavior, inspect the corresponding
`plugin/*.lua` file.
