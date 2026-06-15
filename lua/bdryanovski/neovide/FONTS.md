# Neovide font setup & troubleshooting (macOS)

## Symptom

On launch, Neovide spammed errors in the terminal **and** as a popup inside the
editor window:

```
ERROR [neovide::renderer::fonts::caching_shaper] Font can't be updated to: FontOptions {
    normal: [ "SF Mono", "Menlo", "Monaco", "Courier New", "monospace" ], size: 14.0, ... }
Following fonts couldn't be loaded: SF Mono (Bold Italic/Bold/Italic/None), monospace (...)
ERROR [neovide::bridge::ui_commands] ShowError failed
Caused by: Wrong value type: '2'
```

Later, once `guifont` was set, a second error appeared for
`Iosevka Custom Light Extended` failing in every style.

## Root causes (there were two, independent)

1. **Stale Neovide binary.** `/opt/homebrew/bin/neovide` symlinked to
   `/Applications/Neovide.app` — the old **0.15.2** cask — even though Homebrew
   also had the **0.16.2** formula installed. 0.15.2 has a known startup bug
   where it eagerly loads its hard-coded default font stack
   (`SF Mono`/`monospace`), which don't exist by those names on macOS, and logs
   the failure (plus tries to display it via `ShowError`). 0.16.2 fixed this.

2. **A `guifont` name macOS doesn't expose.** The config used
   `guifont = "Iosevka Custom Light Extended"`. That is a *fontconfig*-style
   name. macOS **Core Text** (what Neovide uses) collapses every Iosevka Custom
   weight/width into a single family — **`Iosevka Custom`** — and Neovim's
   `guifont` can only request bold/italic, **not** a "Light" weight or
   "Extended" width. So Neovide couldn't find the font, logged a load error, and
   silently fell back to a system font.

Key insight: the terminal noise (`RUST_LOG`) and the in-editor popup are
**separate** outputs. `RUST_LOG=off` silences only the terminal half, so it was
never a real fix — the underlying font failure had to be eliminated.

## Resolution

### 1. Point `neovide` at the current version

```sh
brew link --overwrite neovide      # repoints /opt/homebrew/bin/neovide -> 0.16.2 formula
neovide --version                  # should now report 0.16.2
```

(The 0.15.2 `neovide-app` cask is still installed and is used only when
launching from the Dock/Spotlight. `brew uninstall --cask neovide-app` removes
the redundant old app if you only launch from the terminal.)

### 2. Use a font name Core Text actually exposes

List the real family names macOS knows:

```sh
system_profiler SPFontsDataType | grep -E "^\s+Family:" | grep -i iosevka | sort -u
```

`Iosevka Custom` loads cleanly, but it's only the Regular weight. To get the
lighter/wider "Light Extended" look, we minted **new, uniquely-named families**
from the installed Extended faces using `fonttools`, because a family must
include all four styles (Regular/Bold/Italic/Bold-Italic) or Neovide errors on
the missing one.

The build script set, per face: name IDs 1 (Family), 2 (Subfamily), 4 (Full),
6 (PostScript); removed name IDs 16/17 (typographic family/subfamily) so Core
Text groups all four under the family name; and fixed the bold/italic bits
(`OS/2.fsSelection`, `head.macStyle`). Output written to `~/Library/Fonts/`:

| Family | Look | Built from |
|---|---|---|
| `Iosevka Custom ThinExt` | thin + wide (light-extended feel) | ExtendedThin (+ Extended for bold) |
| `Iosevka Custom Ext`     | regular weight + wide              | Extended / ExtendedBold |
| `Iosevka Custom`         | plain regular (fallback)           | shipped |

Files: `~/Library/Fonts/IosevkaCustom{ThinExt,Ext}-{Regular,Bold,Italic,BoldItalic}.ttf`

Recreate them with (fonttools in a throwaway venv):

```sh
python3 -m venv /tmp/fontvenv && /tmp/fontvenv/bin/pip install fonttools
# run the rename script (sets name table + style bits per the table above),
# saving each face under the new family name into ~/Library/Fonts
```

### 3. Set `guifont`

In `lua/bdryanovski/neovide/init.lua`:

```lua
vim.opt.guifont = 'Iosevka Custom ThinExt:h13'
```

Switch the look by changing that one line (then restart Neovide):
`Iosevka Custom Ext:h13` (wider, full weight) or `Iosevka Custom:h13` (plain).
Adjust size with `:h14`, `:h15`, etc.

## How to verify a font actually loads (not just that the option is set)

Launch headless and watch stderr — an empty log means it loaded:

```sh
neovide --no-fork -- --cmd 'set guifont=Iosevka\ Custom\ ThinExt:h13' -u NONE \
  -c 'autocmd UIEnter * lua vim.defer_fn(function() vim.cmd("qa!") end, 1000)'
```

If you see `Font can't be updated` / `No candidate fonts could be loaded`, the
name isn't a Core Text family — pick one from the `system_profiler` list above.
