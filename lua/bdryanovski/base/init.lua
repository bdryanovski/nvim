-- Configuration
--
--
local cnf = vim.opt

cnf.spelllang = { "en" }

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

cnf.scrolloff = 10

-- Searching
cnf.grepprg = "rg --vimgrep"
cnf.ignorecase = true
cnf.smartcase = true

cnf.termguicolors = true
cnf.background = "dark"
cnf.signcolumn = "yes"

cnf.backspace = { "indent", "eol", "start" }

cnf.clipboard:append("unnamedplus")

cnf.splitright = true
cnf.splitbelow = true
cnf.splitkeep = "screen"

cnf.swapfile = false

-- Folding code
cnf.foldlevel = 4
cnf.foldmethod = "expr"
cnf.foldexpr = "nvim_treesitter#foldexpr()"

-- automatically update the content of the file when it change
cnf.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})

if vim.fn.has("nvim-0.10") == 1 then
	cnf.smoothscroll = true
end
