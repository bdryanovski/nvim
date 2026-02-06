return {
	"bassamsdata/namu.nvim",
	opts = {
		global = {},
		namu_symbols = { -- Specific Module options
			options = {},
		},
		movement = {
			next = { "<C-n>", "<DOWN>" }, -- Support multiple keys
			previous = { "<C-p>", "<UP>" }, -- Support multiple keys
			close = { "<ESC>" }, -- close mapping
			select = { "<CR>" }, -- select mapping
			delete_word = {}, -- delete word mapping
			clear_line = {}, -- clear line mapping
		},
		multiselect = {
			enabled = false,
			indicator = "●", -- or "✓"◉
			keymaps = {
				toggle = "<Tab>",
				select_all = "<C-a>",
				clear_all = "<C-l>",
				untoggle = "<S-Tab>",
			},
			max_items = nil, -- No limit by default
		},
		custom_keymaps = {
			yank = {
				keys = { "<C-y>" }, -- yank symbol text
			},
			delete = {
				keys = { "<C-d>" }, -- delete symbol text
			},
			vertical_split = {
				keys = { "<C-v>" }, -- open in vertical split
			},
			horizontal_split = {
				keys = { "<C-h>" }, -- open in horizontal split
			},
			codecompanion = {
				keys = "<C-o>", -- Add symbols to CodeCompanion
			},
			avante = {
				keys = "<C-t>", -- Add symbol to Avante
			},
		},
	},
	-- === Suggested Keymaps: ===
	vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
		desc = "Jump to LSP symbol",
		silent = true,
	}),
	vim.keymap.set("n", "<leader>sd", ":Namu diagnostics<cr>", {
		desc = "LSP Symbols - Diagnostics",
		silent = true,
	}),
}
