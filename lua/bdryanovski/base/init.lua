-- Core Neovim options
--
-- This file groups together UI, editing, search and performance-related
-- `vim.opt` settings. It is loaded from `init.lua`.
vim.opt.spelllang = { "en" } -- Default spell check language for text buffers.

-- Statusline
vim.opt.laststatus = 3 -- 3 = global statusline at the bottom (Neovim 0.7+).

-- Line numbers
vim.opt.relativenumber = true -- Show relative numbers for easier motions.
vim.opt.number = true -- Show absolute number on the current line.

-- Encodings
vim.scriptencoding = "utf-8" -- Encoding for this configuration file.
vim.opt.encoding = "utf-8" -- Internal encoding used by Neovim.
vim.opt.fileencoding = "utf-8" -- Encoding used when writing files.

-- Indentation / tabs
vim.opt.tabstop = 2 -- How many spaces a <Tab> appears as.
vim.opt.shiftwidth = 2 -- Indent width used by >>, <<, etc.
vim.opt.expandtab = true -- Insert spaces instead of literal <Tab> characters.
vim.opt.autoindent = true -- Copy indent from current line when starting a new one.

-- Basic editing UI
vim.opt.wrap = false -- Do not wrap long lines; scroll horizontally instead.
vim.opt.cursorline = true -- Highlight the current line.
vim.opt.showmode = false -- Do not show -- INSERT -- etc. in the command line (statusline handles it).

-- Scrolling
vim.opt.scrolloff = 10 -- Keep 10 lines of context above/below the cursor.

-- Prompts
vim.opt.confirm = true -- Ask for confirmation instead of failing on destructive actions.

-- Editing helpers
vim.opt.colorcolumn = "100" -- Draw a guideline at column 100.
vim.opt.showmatch = true -- Briefly jump to matching bracket when cursor moves over one.

-- Performance
-- @TODO: set to true and fix noise popup error at some point
vim.opt.lazyredraw = false -- When true, delays redrawing during macros; kept false due to UI issues.

-- Searching
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep.
vim.opt.ignorecase = true -- Case-insensitive search by default...
vim.opt.grepformat = "%f:%l:%c:%m" -- ...with file:line:col:message format.
vim.opt.grepprg = "rg --vimgrep"
vim.opt.smartcase = true -- ...but become case-sensitive if the pattern has uppercase.
vim.opt.smartindent = true -- Simple syntax-aware indentation.
vim.opt.iskeyword:append("-") -- Treat `foo-bar` as a single word for motions.
vim.opt.selection = "inclusive" -- Visual selections include the last character.

-- Colors / UI
vim.opt.termguicolors = true -- Enable 24-bit colors.
vim.opt.background = "dark" -- Tell colorschemes we use a dark background.
vim.opt.signcolumn = "yes" -- Always reserve space for diagnostic/git signs.
vim.opt.winminwidth = 5 -- Do not shrink windows below 5 columns.

vim.opt.winborder = "rounded" -- Rounded borders for floating windows.

-- Backspace behaviour in insert mode
vim.opt.backspace = { "indent", "eol", "start" } -- Allow backspace over autoindent, linebreaks and start position.

-- Clipboard integration
vim.opt.clipboard:append("unnamedplus") -- Use the system clipboard as the default register.

-- Fill characters (folds, diff, end-of-buffer, etc.)
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ", -- Hide the default ~ at end-of-buffer.
}

-- Split behaviour
vim.opt.splitright = true -- Vertical splits open to the right of the current window.
vim.opt.splitbelow = true -- Horizontal splits open below.
vim.opt.splitkeep = "screen" -- Try to keep the text on screen stable when splitting.

-- Swap / undo / timing
vim.opt.swapfile = false -- Disable swapfiles; rely on undo files and git.
vim.opt.undofile = true -- Enable persistent undo.
vim.opt.undolevels = 10000 -- Large undo history.
vim.opt.updatetime = 200 -- CursorHold & swap write delay (ms).

-- Folding (Treesitter-based)
vim.opt.foldlevel = 4 -- Keep folds up to this level open by default.
vim.opt.foldmethod = "expr" -- Use an expression to decide folds.
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Treesitter folding expression.

-- Horizontal scrolling / mappings
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible to the left/right of the cursor.
vim.opt.timeoutlen = 300 -- Mapping timeout (ms) for multi-key mappings.

-- Neovim 0.10+ built-in smooth scrolling
if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
end
