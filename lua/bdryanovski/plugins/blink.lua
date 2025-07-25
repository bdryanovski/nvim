return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"Kaiser-Yang/blink-cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},

	event = { "InsertEnter" },

	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- Extend neovim's client capabilities with the completion ones.
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
			flags = {
				debounce_text_changes = 150,
			},
			root_markets = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
		})
	end,

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",

			["<CR>"] = { "accept", "fallback" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		signature = {
			enabled = true,
			trigger = {
				enabled = true,
			},
			window = { show_documentation = true, border = "rounded" },
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			accept = { auto_brackets = { enabled = true } },
			-- range = "full",
			list = {
				max_items = 10,
				selection = { preselect = true, auto_insert = true },
			},

			menu = {
				border = "rounded",

				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon", "kind", gap = 1 },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								local lspkind = require("lspkind")
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				treesitter_highlighting = true,
				window = { border = "rounded" },
			},

			ghost_text = { enabled = false },
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			-- cmdline = {}, -- Disable sources for command-line mode
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				git = {
					module = "blink-cmp-git",
					name = "Git",
					opts = {
						-- options for the blink-cmp-git
					},
				},
				lsp = {
					min_keyword_length = 2, -- Number of characters to trigger porvider
					score_offset = 0, -- Boost/penalize the score of the items
				},
				path = {
					min_keyword_length = 0,
				},
				snippets = {
					min_keyword_length = 2,
				},
				buffer = {
					min_keyword_length = 5,
					max_items = 5,
				},
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- Use a preset for snippets, check the snippets documentation for more information
		snippets = {
			preset = "default",
		},
	},
	opts_extend = { "sources.default" },
}
