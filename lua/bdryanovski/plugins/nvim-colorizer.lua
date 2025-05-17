return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = true,
	opt = {
		filetypes = {
			"html",
			"css",
			"javascript",
			"typescript",
			"typescriptreact",
			"javascriptreact",
			"lua",
		},
	},
}
