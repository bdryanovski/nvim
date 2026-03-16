vim.pack.add({
  "https://github.com/rose-pine/neovim",
  "https://github.com/wnkz/monoglow.nvim",
  "https://github.com/oskarnurm/koda.nvim",
	"https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/vague-theme/vague.nvim",
})

require("rose-pine").setup({
  variant = "moon", -- auto, main, moon, or dawn
  dark_variant = "main", -- main, moon, or dawn
  dim_inactive_windows = true,
  extend_background_behind_borders = true,

  enable = {
    -- terminal = true,

    -- migrations = true, -- Handle deprecated options automatically
  },

  styles = {
    bold = true,
    italic = true,
    transparency = false,
  },

  groups = {
    border = "muted",
    link = "iris",
    panel = "surface",

    error = "love",
    hint = "iris",
    info = "foam",
    note = "pine",
    todo = "rose",
    warn = "gold",

    git_add = "foam",
    git_change = "rose",
    git_delete = "love",
    git_dirty = "rose",
    git_ignore = "muted",
    git_merge = "iris",
    git_rename = "pine",
    git_stage = "iris",
    git_text = "rose",
    git_untracked = "subtle",

    h1 = "iris",
    h2 = "foam",
    h3 = "rose",
    h4 = "gold",
    h5 = "pine",
    h6 = "foam",
  },

  palette = {
    -- Override the builtin palette per variant
    -- moon = {
      --     base = '#18191a',
      --     overlay = '#363738',
      -- },
    },

    -- NOTE: Highlight groups are extended (merged) by default. Disable this
    -- per group via `inherit = false`
    highlight_groups = {
      -- Comment = { fg = "foam" },
      -- StatusLine = { fg = "love", bg = "love", blend = 15 },
      -- VertSplit = { fg = "muted", bg = "muted" },
      -- Visual = { fg = "base", bg = "text", inherit = false },
    },

    before_highlight = function(group, highlight, palette)
      -- Disable all undercurls
      -- if highlight.undercurl then
      --     highlight.undercurl = false
      -- end
      --
      -- Change palette colour
      -- if highlight.fg == palette.pine then
      --     highlight.fg = palette.foam
      -- end
    end,
  })


  require("monoglow").setup({
			-- Change the "glow" color
			on_colors = function(colors)
				colors.glow = "#fd1b7c"
			end,
		})



  require("koda").setup({
    transparent = false, -- enable for transparent backgrounds

    -- Automatically enable highlights only for plugins installed by your plugin manager
    -- Currently only supports `lazy.nvim`, `mini.deps` and `vim.pack`
    auto = true,  -- disable to load ALL available plugin highlights

    cache = true, -- caches the theme for better performance

    -- Style to be applied to different syntax groups
    -- Common use case would be to set either `italic = true` or `bold = true` for a desired group
    -- See `:help nvim_set_hl` for more valid values
    styles = {
       functions = { bold = true },
       keywords  = {},
       comments  = {},
       strings   = {},
       constants = {}, -- includes numbers, booleans
    },

    -- Override colors for the active variant
    -- Available keys (e.g., 'func') can be found in lua/koda/palette/
    colors = {
      -- func = "#4078F2",
      -- keyword = "#A627A4",
    },

    -- You can modify or extend highlight groups using the `on_highlights` configuration option
    -- Any changes made take effect when highlights are applied
    on_highlights = function(hl, c)
      -- hl.LineNr = { fg = c.info } -- change a specific highlight to use a different palette color
      -- hl.Comment = { fg = c.emphasis, italic = true } -- modify a syntax group (add bold, italic, etc)
      -- hl.RainbowDelimiterRed = { fg = "#fb2b2b" } -- add a custom highlight group for another plugin
    end,
})

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



			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = true, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.55, -- percentage of the shade to apply to the inactive window
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
					numbers = { "italic" },
					booleans = {},
					properties = {},
					types = { "italic" },
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					alpha = true,
					blink_cmp = true,
					gitsigns = true,
					treesitter = true,
					treesitter_context = true,
					fzf = true,
					noice = true,
					notify = true,
					which_key = true,
					telescope = false,
					lsp_trouble = true,
					dap_ui = true,
					dap = {
						enabled = true,
						enable_ui = true,
					},
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
							ok = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
							ok = { "underline" },
						},
						inlay_hints = {
							background = true,
						},
					},
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})

	require("vague").setup({
			transparent = true, -- don't set background
			-- disable bold/italic globally in `style`
			bold = true,
			italic = true,
			style = {
				-- "none" is the same thing as default. But "italic" and "bold" are also valid options
				boolean = "bold",
				number = "none",
				float = "none",
				error = "bold",
				comments = "italic",
				conditionals = "none",
				functions = "none",
				headings = "bold",
				operators = "none",
				strings = "none",
				variables = "bold",

				-- keywords
				keywords = "none",
				keyword_return = "bold",
				keywords_loop = "none",
				keywords_label = "none",
				keywords_exception = "none",

				-- builtin
				builtin_constants = "bold",
				builtin_functions = "none",
				builtin_types = "bold",
				builtin_variables = "none",
			},
			-- plugin styles where applicable
			-- make an issue/pr if you'd like to see more styling options!
			plugins = {
				cmp = {
					match = "bold",
					match_fuzzy = "bold",
				},
				dashboard = {
					footer = "italic",
				},
				lsp = {
					diagnostic_error = "bold",
					diagnostic_hint = "none",
					diagnostic_info = "italic",
					diagnostic_ok = "none",
					diagnostic_warn = "bold",
				},
			},

			-- Override colors
			colors = {
				bg = "#141415",
				inactiveBg = "#1c1c24",
				fg = "#cdcdcd",
				floatBorder = "#878787",
				line = "#252530",
				comment = "#606079",
				builtin = "#b4d4cf",
				func = "#c48282",
				string = "#e8b589",
				number = "#e0a363",
				property = "#c3c3d5",
				constant = "#aeaed1",
				parameter = "#bb9dbd",
				visual = "#333738",
				error = "#d8647e",
				warning = "#f3be7c",
				hint = "#7e98e8",
				operator = "#90a0b5",
				keyword = "#6e94b2",
				type = "#9bb4bc",
				search = "#405065",
				plus = "#7fa563",
				delta = "#f3be7c",
			},
		})

  -- Load scheme

  vim.cmd("colorscheme rose-pine")
