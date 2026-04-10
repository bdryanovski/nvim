# Neovim Configuration

A personal Neovim configuration built on top of Neovim's native capabilities,
using `vim.pack` for plugin management with a custom lazy-loading layer.

## Requirements

- **Neovim** >= 0.10 (0.11+ recommended for full feature support)
- **Git** — for plugin installation via `vim.pack`
- **[Nerd Font](https://www.nerdfonts.com/)** — for icons throughout the UI
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`) — used as the default `grepprg`
- **[fd](https://github.com/sharkdp/fd)** — for file finding in fzf-lua
- **[Cargo / Rust](https://www.rust-lang.org/tools/install)** — required to build `blink.cmp`
- **[delta](https://github.com/dandavison/delta)** — for git diff previews
- **[Node.js](https://nodejs.org/)** — required by several LSP servers

Optional, but recommended:

- **[Neovide](https://neovide.dev/)** — GPU-accelerated GUI front-end (config included)

## Installation

Clone directly into the Neovim config directory:

```bash
git clone <repo-url> ~/.config/nvim
```

On first launch Neovim will install all plugins via `vim.pack`.
`blink.cmp` requires a Rust build step that runs automatically after
install/update (triggered by the `PackChanged` autocommand in `init.lua`).

Measure startup time at any point with:

```bash
nvim --startuptime startuptime.log .
```

## Structure

```
~/.config/nvim/
├── init.lua                  # Entry point — options, module requires, autocmds
├── plugin/                   # Auto-sourced plugin configs (one file per plugin)
│   ├── 00-dependencies.lua   # Core dependencies (plenary.nvim)
│   ├── 01-mini.lua           # mini.nvim suite
│   ├── blink.cmp.lua         # Completion engine
│   ├── conform.nvim.lua      # Format-on-save
│   ├── copilot.lua           # GitHub Copilot
│   ├── fzf-lua.lua           # Fuzzy finder
│   ├── gitsigns.nvim.lua     # Git decorations
│   ├── noice.lua             # UI overrides (cmdline, messages)
│   ├── snacks.nvim.lua       # Dashboard, smooth scroll, dim
│   ├── themes.lua            # Colour scheme setup & activation
│   ├── treesitter.lua        # Syntax / parsing + Mason
│   └── ...                   # Other plugin configs
├── lua/bdryanovski/
│   ├── base/                 # Core Neovim options, mappings, autocmds
│   │   ├── init.lua          # vim.opt settings
│   │   ├── mapping.lua       # Keybindings
│   │   └── autocmd.lua       # Global autocommands
│   ├── core/
│   │   └── lsp.lua           # LSP client setup and diagnostics config
│   ├── custom/               # Local plugins (bookmarks, indent, navbar, peacock, togglewords)
│   ├── neovide/              # Neovide-specific settings
│   ├── pack.lua              # Lazy-loading wrapper around vim.pack
│   └── plugins/              # Extra plugin specs (go.nvim, trouble, luasnip, …)
├── lsp/                      # Per-server LSP config files (vim.lsp.config)
└── snippets/                 # Custom snippets
```

## Plugin Management

Plugins are managed with Neovim's built-in `vim.pack`, augmented by a thin
custom wrapper at `lua/bdryanovski/pack.lua` that adds lazy loading via
`event` and `ft` triggers.

### `bdryanovski.pack` — lazy-loading wrapper

`vim.pack` loads everything eagerly by default. `pack.lua` extends it with two
optional fields on a spec table:

| Field     | Type               | Description                               |
| --------- | ------------------ | ----------------------------------------- |
| `src`     | `string`           | Remote Git URL                            |
| `dir`     | `string`           | Local filesystem path                     |
| `name`    | `string`           | Override the inferred plugin name         |
| `version` | `string\|Range`    | Version constraint forwarded to vim.pack  |
| `event`   | `string\|string[]` | Autocommand event(s) that trigger loading |
| `ft`      | `string\|string[]` | Filetype(s) that trigger loading          |
| `config`  | `function`         | Called once after the plugin is loaded    |
| `enabled` | `boolean`          | Set to `false` to skip entirely           |

Specs **without** `event`/`ft` are passed straight through to `vim.pack` and
loaded immediately. Specs **with** `event`/`ft` are installed on disk but
deferred until the trigger fires.

#### Examples

```lua
local pack = require("bdryanovski.pack")

-- Immediate load (plain vim.pack passthrough)
pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
})

-- Lazy load on event
pack.add({
  src = "https://github.com/nvim-mini/mini.completion",
  event = "InsertEnter",
  config = function()
    require("mini.completion").setup()
  end,
})

-- Lazy load on filetype
pack.add({
  src = "https://github.com/ray-x/go.nvim",
  ft = { "go", "gomod" },
  config = function()
    require("go").setup()
  end,
})

-- Local plugin with lazy loading
pack.add({
  dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/indent",
  name = "indent",
  event = "BufReadPost",
  config = function()
    require("bdryanovski.custom.indent").setup({})
  end,
})
```

> `VeryLazy` is a special synthetic event: it maps to `UIEnter` deferred with
> `vim.schedule`, mirroring the same convention used by lazy.nvim.

## Key Bindings

`<leader>` is set to `,`.

### General

| Mapping      | Mode    | Description                     |
| ------------ | ------- | ------------------------------- |
| `<leader>nh` | n       | Clear search highlights         |
| `<C-a>`      | n       | Select all                      |
| `<C-s>`      | i/x/n/s | Save file                       |
| `+` / `-`    | n       | Increment / Decrement number    |
| `H`          | n       | Go to first non-blank character |
| `<leader>qq` | n       | Quit all                        |
| `<C-j>`      | n       | Go to next diagnostic           |

### Window Management

| Mapping          | Description              |
| ---------------- | ------------------------ |
| `ss`             | Split horizontally       |
| `sv`             | Split vertically         |
| `<Space>`        | Go to next window        |
| `s<arrow>`       | Go to directional window |
| `<C-Up/Down>`    | Resize window height     |
| `<C-Left/Right>` | Resize window width      |

### Tabs

| Mapping      | Description       |
| ------------ | ----------------- |
| `<leader>te` | Create new tab    |
| `<Tab>`      | Next tab          |
| `<S-Tab>`    | Previous tab      |
| `<C-w>`      | Close current tab |

### Fuzzy Finder (`fzf-lua`)

| Mapping      | Description              |
| ------------ | ------------------------ |
| `<leader>ff` | Find files               |
| `<leader>fb` | Find buffers             |
| `<leader>f/` | Recent files             |
| `<leader>fr` | Resume last search       |
| `<leader>fs` | Live grep                |
| `<leader>fc` | Search word under cursor |
| `<leader>fv` | Search visual selection  |

### LSP

| Mapping      | Description                     |
| ------------ | ------------------------------- |
| `K`          | Hover documentation             |
| `<C-k>`      | Signature help                  |
| `<leader>d`  | Show line diagnostics           |
| `gK`         | Toggle virtual diagnostic lines |
| `<leader>th` | Toggle inlay hints              |
| `<leader>gr` | LSP references                  |
| `<leader>gd` | LSP definitions                 |
| `<leader>li` | LSP implementations             |
| `<leader>lt` | LSP type definitions            |
| `<leader>ls` | Document symbols                |
| `<leader>lw` | Workspace symbols               |
| `<leader>ca` | Code actions                    |

### Diagnostics

| Mapping      | Description           |
| ------------ | --------------------- |
| `<leader>dd` | Document diagnostics  |
| `<leader>dw` | Workspace diagnostics |

## LSP

LSP servers are enabled via `vim.lsp.enable()` in `lua/bdryanovski/core/lsp.lua`.
Per-server configuration lives in individual files under `lsp/`.

Enabled servers:

| Language           | Server(s)                  |
| ------------------ | -------------------------- |
| Lua                | `lua_ls`                   |
| TypeScript / JS    | `ts_ls`, `html`, `cssls`   |
| Astro              | `astro_ls`                 |
| Rust               | `rust_analyzer`            |
| Go                 | `gopls`                    |
| PHP                | `intelephense`, `phpactor` |
| C / C++            | `clangd`                   |
| Linting/Formatting | `oxlint`, `oxfmt`          |

Capabilities are set globally in `plugin/blink.cmp.lua` and forwarded to
every server via `vim.lsp.config("*", { capabilities = … })`.

Mason is used to install the underlying language-server binaries
(`plugin/treesitter.lua`).

## Formatting

Formatting is handled by **conform.nvim** with format-on-save enabled by
default. The formatter selection falls back gracefully (prettier → oxfmt for
JS/TS, stylua for Lua, gofmt for Go, etc.).

To disable format-on-save:

```
:FormatDisable        " globally
:FormatDisable!       " for current buffer only
:FormatEnable         " re-enable
```

## Themes

Multiple colour schemes are configured and available. The active scheme is
**rose-pine** (moon variant), loaded at the end of `plugin/themes.lua`.

Available schemes:

- `rose-pine` (active)
- `monoglow`
- `koda`
- `kanagawa`
- `catppuccin`
- `vague`

Switch with `:colorscheme <name>`.

## Custom Plugins

Local plugins live under `lua/bdryanovski/custom/` and are loaded through
`pack.lua` using `dir` specs.

| Plugin        | Description                                    |
| ------------- | ---------------------------------------------- |
| `bookmarks`   | Named file bookmarks                           |
| `indent`      | Custom indent guide rendering                  |
| `navbar`      | Winbar breadcrumb showing file path / symbol   |
| `peacock`     | Per-project window accent colours              |
| `togglewords` | Cycle through word variants (true/false, etc.) |

## Dashboard ASCII Art

The Snacks.nvim dashboard header uses Braille block characters. The full
Braille Unicode table used for animations and signs is preserved here for
reference:

```
⠀⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏
⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟
⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯
⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿
⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏
⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟
⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯
⡰⡱⡲⡳⡴⡵⡶⡷⡸⡹⡺⡻⡼⡽⡾⡿
⢀⢁⢂⢃⢄⢅⢆⢇⢈⢉⢊⢋⢌⢍⢎⢏
⢐⢑⢒⢓⢔⢕⢖⢗⢘⢙⢚⢛⢜⢝⢞⢟
⢠⢡⢢⢣⢤⢥⢦⢧⢨⢩⢪⢫⢬⢭⢮⢯
⢰⢱⢲⢳⢴⢵⢶⢷⢸⢹⢺⢻⢼⢽⢾⢿
⣀⣁⣂⣃⣄⣅⣆⣇⣈⣉⣊⣋⣌⣍⣎⣏
⣐⣑⣒⣓⣔⣕⣖⣗⣘⣙⣚⣛⣜⣝⣞⣟
⣤⣡⣢⣣⣤⣥⣦⣧⣨⣩⣪⣫⣬⣭⣮⣯
⣰⣱⣲⣳⣴⣵⣶⣷⣸⣹⣺⣻⣼⣽⣾⣿
```

..
