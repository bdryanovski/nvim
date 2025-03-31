return {
	"nvim-tree/nvim-tree.lua",
	tag = "nvim-tree-v1.9.0",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- change color for arrows in tree to light blue
		vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
		vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

		local WIDTH_RATIO = 0.5
		local HEIGHT_RATIO = 0.8

		-- configure nvim-tree
		require("nvim-tree").setup({
			sort_by = "name",
			auto_reload_on_write = true,
			prefer_startup_root = false,
			sync_root_with_cwd = false,
			reload_on_bufenter = false,
			respect_buf_cwd = false,
			view = {
				adaptive_size = false,
				side = "left",
				number = false,
				relativenumber = false,
				signcolumn = "yes",
				width = function()
					return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
				end,
				float = {
					enable = true,
					quit_on_focus_loss = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local window_w = screen_w * WIDTH_RATIO
						local window_h = screen_h * HEIGHT_RATIO
						local window_w_int = math.floor(window_w)
						local window_h_int = math.floor(window_h)
						local center_x = (screen_w - window_w) / 2
						local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
						return {
							border = "rounded",
							relative = "editor",
							row = center_y,
							col = center_x,
							width = window_w_int,
							height = window_h_int,
						}
					end,
				},
			},
			-- change folder arrow icons
			renderer = {
				add_trailing = false,
				group_empty = false,
				full_name = false,
				highlight_opened_files = "name",
				root_folder_label = ":~:s?$?/..?",
				indent_width = 2,
				special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
				indent_markers = {
					enable = true,
					inline_arrows = false,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},
				icons = {
					webdev_colors = true,
					git_placement = "before",
					padding = " ",
					show = {
						file = true,
						folder = true,
						git = true,
					},
					glyphs = {
						default = "",
						symlink = "",
						bookmark = "",
						folder = {
							arrow_closed = "", -- "",arrow when folder is closed
							arrow_open = "", -- "",arrow when folder is open
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
			diagnostics = {
				enable = false,
				show_on_dirs = false,
				show_on_open_dirs = true,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				use_system_clipboard = true,
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				enable = true,
				ignore = false,
				timeout = 400,
			},
			update_focused_file = {
				enable = true,
				update_root = false,
				ignore_list = {},
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
