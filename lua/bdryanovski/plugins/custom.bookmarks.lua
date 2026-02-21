return {
	dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/bookmarks",
	name = "bookmarks",
	main = "bdryanovski/custom/bookmarks",
	event = "VeryLazy",
	config = function()
		require("bdryanovski/custom/bookmarks").setup({
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
	end,
}
