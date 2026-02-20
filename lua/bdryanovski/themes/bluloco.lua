return {
	"uloco/bluloco.nvim",
	lazy = false,
	priority = 1000,
	dependencies = { "rktjmp/lush.nvim" },
	config = function()
		-- your optional config goes here, see below.
		require("bluloco").setup({
			style = "auto", -- "auto" | "dark" | "light"
			transparent = false,
			italics = true,
			terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
			guicursor = true,
			rainbow_headings = false, -- if you want different colored headings for each heading level
			float_window = "default", -- "default" | "transparent"
		})

		vim.opt.termguicolors = true
	end,
}
