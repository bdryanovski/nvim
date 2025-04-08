return {
	{
		"b0o/incline.nvim",
		dependencies = {},
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local devicons = require("nvim-web-devicons")
			local navic = require("nvim-navic")
			local helpers = require("incline.helpers")
			require("incline").setup({
				window = {
					padding = 0,
					margin = { horizontal = 0 },
				},
				hide = { cursorline = true },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if filename == "" then
						filename = "[No Name]"
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)

					local function get_git_diff()
						local icons = { removed = " ", changed = " ", added = " " }
						local signs = vim.b[props.buf].gitsigns_status_dict
						local labels = {}
						if signs == nil then
							return labels
						end
						for name, icon in pairs(icons) do
							if tonumber(signs[name]) and signs[name] > 0 then
								table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
							end
						end
						-- if #labels > 0 then
						-- 	table.insert(labels, { "┊ " })
						-- end
						return labels
					end

					local function get_diagnostic_label()
						local icons = { error = " ", warn = " ", info = " ", hint = " " }
						local label = {}

						for severity, icon in pairs(icons) do
							local n = #vim.diagnostic.get(
								props.buf,
								{ severity = vim.diagnostic.severity[string.upper(severity)] }
							)
							if n > 0 then
								table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
							end
						end
						if #label > 0 then
							table.insert(label, { "┊ " })
						end
						return label
					end

					local res = {
						-- { get_diagnostic_label() },
						-- { get_git_diff() },
						ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
							or "",
						{ " " .. filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
					}

					if props.focused then
						for _, item in ipairs(navic.get_data(props.buf) or {}) do
							table.insert(res, {
								{ " > ", group = "NavicSeparator" },
								{ item.icon, group = "NavicIcons" .. item.type },
								{ item.name, group = "NavicText" },
							})
						end
					end

					table.insert(res, " ")

					return res
				end,
			})
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		event = "VeryLazy",
		config = function()
			-- configure
			require("scrollbar").setup({
				show = true,
				show_in_active_only = false,
				set_highlights = true,
				folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
				max_lines = false, -- disables if no. of lines in buffer exceeds this
				hide_if_all_visible = false, -- Hides everything if all lines are visible
				throttle_ms = 100,
				handle = {
					text = " ",
					blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
					color = nil,
					color_nr = nil, -- cterm
					highlight = "CursorColumn",
					hide_if_all_visible = true, -- Hides handle if all lines are visible
				},
				marks = {
					Cursor = {
						text = "•",
						priority = 0,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "Normal",
					},
					Search = {
						text = { "-", "=" },
						priority = 1,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "Search",
					},
					Error = {
						text = { "-", "=" },
						priority = 2,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "DiagnosticVirtualTextError",
					},
					Warn = {
						text = { "-", "=" },
						priority = 3,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "DiagnosticVirtualTextWarn",
					},
					Info = {
						text = { "-", "=" },
						priority = 4,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "DiagnosticVirtualTextInfo",
					},
					Hint = {
						text = { "-", "=" },
						priority = 5,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "DiagnosticVirtualTextHint",
					},
					Misc = {
						text = { "-", "=" },
						priority = 6,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "Normal",
					},
					GitAdd = {
						text = "┆",
						priority = 7,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "GitSignsAdd",
					},
					GitChange = {
						text = "┆",
						priority = 7,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "GitSignsChange",
					},
					GitDelete = {
						text = "▁",
						priority = 7,
						gui = nil,
						color = nil,
						cterm = nil,
						color_nr = nil, -- cterm
						highlight = "GitSignsDelete",
					},
				},
				excluded_buftypes = {
					"terminal",
				},
				excluded_filetypes = {
					"cmp_docs",
					"cmp_menu",
					"noice",
					"prompt",
					"TelescopePrompt",
				},
				autocmd = {
					render = {
						"BufWinEnter",
						"TabEnter",
						"TermEnter",
						"WinEnter",
						"CmdwinLeave",
						"TextChanged",
						"VimResized",
						"WinScrolled",
					},
					clear = {
						"BufWinLeave",
						"TabLeave",
						"TermLeave",
						"WinLeave",
					},
				},
				handlers = {
					cursor = true,
					diagnostic = true,
					gitsigns = false, -- Requires gitsigns
					handle = true,
					search = false, -- Requires hlslens
					ale = false, -- Requires ALE
				},
			})
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
}
