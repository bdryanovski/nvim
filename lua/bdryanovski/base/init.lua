-- Configuration
--
--
vim.opt.spelllang = { "en" }

vim.opt.laststatus = 3 -- Show status line in all windows

vim.opt.relativenumber = true
vim.opt.number = true

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.tabstop = 2 -- 2 spaces for one tab
vim.opt.shiftwidth = 2 -- 2 spaces for one indent
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.showmode = false -- Don't show mode in the command line

vim.opt.scrolloff = 10

vim.opt.confirm = true -- Confirm before overwriting files

-- editing
vim.opt.colorcolumn = "100" -- show a column at 100 position chars
vim.opt.showmatch = true -- show matching brackets when text indicator is over them
--
-- perf
-- @TODO: set to true and fix noise popup error at some point
vim.opt.lazyredraw = false -- don't redraw while executing macros (good performance config)

-- Searching
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.iskeyword:append("-") -- consider string-string as whole word
vim.opt.selection = "inclusive" -- include the last character of a selection

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.winminwidth = 5

vim.opt.winborder = "rounded"

vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.clipboard:append("unnamedplus")

vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold

-- Folding code
vim.opt.foldlevel = 4
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds)

if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
end
