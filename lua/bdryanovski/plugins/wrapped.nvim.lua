return {
	"aikhe/wrapped.nvim",
	dependencies = { "nvzone/volt" },
	cmd = { "NvimWrapped" },
	opts = {
		path = vim.fn.stdpath("config"), -- path to your neovim configuration (defaults to nvim config)
		border = false,
		size = {
			width = 120,
			height = 40,
		},
		exclude_filetype = {
			".gitmodules",
		},
		cap = {
			commits = 1000,
			plugins = 100,
			plugins_ever = 200,
			lines = 10000,
		},
	},
}
