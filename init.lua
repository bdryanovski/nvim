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

-- require("navbar")

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

require("bdryanovski.custom.indent").setup({
	-- Draw options
	draw = {
		-- Delay (in ms) between event and start of drawing scope indicator
		delay = 100,

		-- Animation rule for scope's first drawing. A function which, given
		-- next and total step numbers, returns wait time (in ms). See
		-- |MiniIndentscope.gen_animation| for builtin options. To disable
		-- animation, use `require('mini.indentscope').gen_animation.none()`.
		-- animation = --<function: implements constant 20ms between steps>,

		-- Whether to auto draw scope: return `true` to draw, `false` otherwise.
		-- Default draws only fully computed scope (see `options.n_lines`).
		predicate = function(scope)
			return not scope.body.is_incomplete
		end,

		-- Symbol priority. Increase to display on top of more symbols.
		priority = 2,
	},

	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		-- Textobjects
		object_scope = "ii",
		object_scope_with_border = "ai",

		-- Motions (jump to respective border line; if not present - body line)
		goto_top = "[i",
		goto_bottom = "]i",
	},

	-- Options which control scope computation
	options = {
		-- Type of scope's border: which line(s) with smaller indent to
		-- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
		border = "both",

		-- Whether to use cursor column when computing reference indent.
		-- Useful to see incremental scopes with horizontal cursor movements.
		indent_at_cursor = true,

		-- Maximum number of lines above or below within which scope is computed
		n_lines = 10000,

		-- Whether to first check input line to be a border of adjacent scope.
		-- Use it if you want to place cursor on function header to get scope of
		-- its body.
		try_as_border = false,
	},

	-- Which character to use for drawing scope indicator
	symbol = "┊",
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
