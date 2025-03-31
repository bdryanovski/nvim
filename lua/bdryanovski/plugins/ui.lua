return {
	-- Dressing.nvim is a Neovim plugin designed to enhance the user interface by providing improved input and selection dialogs.
	-- It aims to offer a more visually appealing and customizable experience compared to the default Neovim UI components.
	-- The plugin leverages Neovim's built-in capabilities and integrates seamlessly with other plugins, allowing users to
	-- tailor the appearance and behavior of dialogs to better fit their workflow. Dressing.nvim is particularly useful for
	-- users who want a more modern and consistent look across various UI elements in Neovim.
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			-- Set to false to disable the vim.ui.input implementation
			enabled = true,

			-- Default prompt string
			default_prompt = "Input:",

			-- Trim trailing `:` from prompt
			trim_prompt = false,

			-- Can be 'left', 'right', or 'center'
			title_pos = "left",

			-- When true, <Esc> will close the modal
			insert_only = true,

			-- When true, input will start in insert mode.
			start_in_insert = true,

			-- These are passed to nvim_open_win
			border = "rounded",
			-- 'editor' and 'win' will default to being centered
			relative = "cursor",

			-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			prefer_width = 40,
			width = nil,
			-- min_width and max_width can be a list of mixed types.
			-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
			max_width = { 140, 0.9 },
			min_width = { 20, 0.2 },

			buf_options = {},
			win_options = {
				-- Disable line wrapping
				wrap = false,
				-- Indicator for when text exceeds window
				list = true,
				listchars = "precedes:…,extends:…",
				-- Increase this for more context when text scrolls off the window
				sidescrolloff = 0,
			},

			-- Set to `false` to disable
			mappings = {
				n = {
					["<Esc>"] = "Close",
					["<CR>"] = "Confirm",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<Up>"] = "HistoryPrev",
					["<Down>"] = "HistoryNext",
				},
			},

			-- A common way to adjust the highlighting of just the dressing windows is by
			-- providing a winhighlight option in the config. See :help winhighlight for more details.
			-- Example:
			win_options = {
				winhighlight = "NormalFloat:DiagnosticError",
			},

			override = function(conf)
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				return conf
			end,

			-- see :help dressing_get_config
			get_config = nil,
		},
		select = {
			-- Set to false to disable the vim.ui.select implementation
			enabled = true,

			-- Priority list of preferred vim.select implementations
			backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

			-- Trim trailing `:` from prompt
			trim_prompt = true,

			-- Options for telescope selector
			-- These are passed into the telescope picker directly. Can be used like:
			-- telescope = require('telescope.themes').get_ivy({...})
			telescope = nil,

			-- Options for fzf selector
			fzf = {
				window = {
					width = 0.5,
					height = 0.4,
				},
			},

			-- Options for fzf-lua
			fzf_lua = {
				-- winopts = {
				--   height = 0.5,
				--   width = 0.5,
				-- },
			},

			-- Options for nui Menu
			nui = {
				position = "50%",
				size = nil,
				relative = "editor",
				border = {
					style = "rounded",
				},
				buf_options = {
					swapfile = false,
					filetype = "DressingSelect",
				},
				win_options = {
					winblend = 0,
				},
				max_width = 80,
				max_height = 40,
				min_width = 40,
				min_height = 10,
			},

			-- Options for built-in selector
			builtin = {
				-- Display numbers for options and set up keymaps
				show_numbers = true,
				-- These are passed to nvim_open_win
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "editor",

				buf_options = {},
				win_options = {
					cursorline = true,
					cursorlineopt = "both",
				},

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- the min_ and max_ options can be a list of mixed types.
				-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
				width = nil,
				max_width = { 140, 0.8 },
				min_width = { 40, 0.2 },
				height = nil,
				max_height = 0.9,
				min_height = { 10, 0.2 },

				-- Set to `false` to disable
				mappings = {
					["<Esc>"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},

				override = function(conf)
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					return conf
				end,
			},

			-- Used to override format_item. See :help dressing-format
			format_item_override = {},
		},
	},
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
	{
		"declancm/cinnamon.nvim",
		version = "*", -- use latest release
		opts = {
			-- change default options here
			-----@class CinnamonOptions
			-- Disable the plugin
			disabled = false,

			keymaps = {
				-- Enable the provided 'basic' keymaps
				basic = true,
				-- Enable the provided 'extra' keymaps
				extra = true,
			},

			---@class ScrollOptions
			options = {
				-- The scrolling mode
				-- `cursor`: animate cursor and window scrolling for any movement
				-- `window`: animate window scrolling ONLY when the cursor moves out of view
				mode = "cursor",

				-- Only animate scrolling if a count is provided
				count_only = false,

				-- Delay between each movement step (in ms)
				delay = 5,

				max_delta = {
					-- Maximum distance for line movements before scroll
					-- animation is skipped. Set to `false` to disable
					line = 40,
					-- Maximum distance for column movements before scroll
					-- animation is skipped. Set to `false` to disable
					column = false,
					-- Maximum duration for a movement (in ms). Automatically scales the
					-- delay and step size
					time = 500,
				},

				step_size = {
					-- Number of cursor/window lines moved per step
					vertical = 1,
					-- Number of cursor/window columns moved per step
					horizontal = 2,
				},

				-- Optional post-movement callback. Not called if the movement is interrupted
				callback = function() end,
			},
		},
	},
}
