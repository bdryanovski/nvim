if vim.loader then
	vim.loader.enable()
end

if vim.opt.termguicolors then
	vim.opt.termguicolors = true
end

-- Global variables.
vim.g.projects_dir = vim.env.HOME .. "/Projects"

vim.g.github_projects_dir = vim.env.HOME .. "/Github"
vim.g.work_projects_dir = vim.env.HOME .. "/Manual"

require("navbar")

require("bdryanovski.base")
require("bdryanovski.base.autocmd")
require("bdryanovski.base.mapping")
require("bdryanovski.core.lsp")
require("bdryanovski.lazy")
require("bdryanovski.neovide")

-- Custom plugins section
--
require("bdryanovski.custom.bookmarks").setup({
	sign = {
		text = "📍",
		texthl = "DiagnosticInfo",
		priority = 20,
	},
	keymaps = {
		toggle = "mb",
		next = "]b",
		prev = "[b",
		list = "<leader>bl",
	},
	persist = true,
})

require("bdryanovski.custom.togglewords").setup({
	pairs = {
		{ "true", "false" },
		{ "on", "off" },
		{ "start", "stop" },
	},
	keymap = "<leader>x",
})
require("bdryanovski.custom.peacock").setup({
	bar_enabled = false, -- When this is enabled (default) the left most window will show its signcolumn with the project color.
	sign_column_width = 1, -- This is the width of the bar sowhing in the left most window.
	eob_enabled = true, -- To give a more unified look we set the eob character to █ and color it to the project color
})

local nvim_set_hl = vim.api.nvim_set_hl
-- Apply Peacock color to other UI components
nvim_set_hl(0, "WinSeparator", { link = "PeacockFg" })
nvim_set_hl(0, "FloatBorder", { link = "PeacockFg" })
nvim_set_hl(0, "LineNr", { link = "PeacockFg" })
