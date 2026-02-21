return {
	dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/togglewords",
	name = "togglewords",
	main = "bdryanovski/custom/togglewords",
	event = "BufReadPost",
	config = function()
		require("bdryanovski/custom/togglewords").setup({
			pairs = {
				{ "true", "false" },
				{ "on", "off" },
				{ "start", "stop" },
			},
			keymap = "<leader>x",
		})
	end,
}
