return {
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_transparent_background = "0"
			vim.g.sonokai_better_performance = "1"
			vim.g.sonokai_enable_italic = "1"
			vim.g.sonokai_disable_italic_comment = "0"
			vim.g.sonokai_dim_inactive_windows = "1"
			vim.g.sonokai_menu_selection_background = "green"
			vim.g.sonokai_diagnostic_text_highlight = 1
			vim.g.sonokai_diagnostic_line_highlight = 1
			vim.g.sonokai_diagnostic_virtual_text = "colored"
			vim.g.sonokai_current_word = "underline"
			vim.g.sonokai_inlay_hints_background = "dimmed"
			vim.g.sonokai_cursor = "red"
			vim.g.sonokai_style = "andromeda"
			-- vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"bluz71/vim-nightfly-guicolors",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			-- vim.cmd([[colorscheme nightfly]])
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					blink_cmp = true,
					telescope = true,
					notify = false,
					lsp_trouble = true,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})
			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
