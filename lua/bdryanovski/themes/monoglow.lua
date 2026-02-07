return {
	"wnkz/monoglow.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("monoglow").setup({
			-- Change the "glow" color
			on_colors = function(colors)
				colors.glow = "#fd1b7c"
			end,
		})
	end,
}
