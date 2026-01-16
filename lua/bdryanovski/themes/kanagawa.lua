return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			compile = true,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			variablebuiltinStyle = { italic = true },
			specialReturn = true,
			specialException = true,
			transparent = false,
			dimInactive = false,
			globalStatus = false,
			terminalColors = true,
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					-- Customize normal background
					NormalFloat = { bg = theme.ui.bg_p1 },
					-- Customize cursor line background
					CursorLineNr = { fg = theme.ui.fg_bright, bold = true },
				}
			end,
		})
		vim.cmd("colorscheme kanagawa-wave")
	end,
}
