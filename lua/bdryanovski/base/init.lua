-- Configuration
--
--
local cnf = vim.opt

cnf.spelllang = { "en" }

cnf.laststatus = 3 -- Show status line in all windows

cnf.relativenumber = true
cnf.number = true

vim.scriptencoding = "utf-8"
cnf.encoding = "utf-8"
cnf.fileencoding = "utf-8"

cnf.tabstop = 2 -- 2 spaces for one tab
cnf.shiftwidth = 2 -- 2 spaces for one indent
cnf.expandtab = true
cnf.autoindent = true

cnf.wrap = false
cnf.cursorline = true
cnf.showmode = false -- Don't show mode in the command line

cnf.scrolloff = 10

cnf.confirm = true -- Confirm before overwriting files

-- Searching
cnf.grepprg = "rg --vimgrep"
cnf.ignorecase = true
cnf.grepformat = "%f:%l:%c:%m"
cnf.grepprg = "rg --vimgrep"
cnf.smartcase = true
cnf.smartindent = true

cnf.termguicolors = true
cnf.background = "dark"
cnf.signcolumn = "yes"
cnf.winminwidth = 5

cnf.backspace = { "indent", "eol", "start" }

cnf.clipboard:append("unnamedplus")

cnf.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

cnf.splitright = true
cnf.splitbelow = true
cnf.splitkeep = "screen"

cnf.swapfile = false
cnf.undofile = true
cnf.undolevels = 10000
cnf.updatetime = 200 -- Save swap file and trigger CursorHold

-- Folding code
cnf.foldlevel = 4
cnf.foldmethod = "expr"
cnf.foldexpr = "nvim_treesitter#foldexpr()"

cnf.sidescrolloff = 8 -- Columns of context
cnf.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds)

if vim.fn.has("nvim-0.10") == 1 then
	cnf.smoothscroll = true
end
