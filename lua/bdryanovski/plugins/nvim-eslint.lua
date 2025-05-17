return {
	"esmuellert/nvim-eslint",
	config = function()
		require("nvim-eslint").setup({
			settings = {
				format = true,
			},
		})
	end,
}
