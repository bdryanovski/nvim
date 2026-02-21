return {
	dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/navbar",
	name = "navbar",
	main = "bdryanovski/custom/navbar",
	event = "VeryLazy",
	config = function()
		require("bdryanovski/custom/navbar")
	end,
}
