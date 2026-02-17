return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
		build = ":TSUpdate",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				lazy = true,
			},
		},
		cmd = {
			"TSBufDisable",
			"TSBufEnable",
			"TSBufToggle",
			"TSDisable",
			"TSEnable",
			"TSToggle",
			"TSInstall",
			"TSInstallInfo",
			"TSInstallSync",
			"TSModuleInfo",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"astro",
					"tsx",
					"yaml",
					"html",
					"css",
					"sql",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"scss",
					"dockerfile",
					"gitignore",
					"query",
					"rust",
					"go",
				},
				-- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
		end,
	},
}
