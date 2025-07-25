-- Documentation: https://github.com/zbirenbaum/copilot.lua
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		-- The panel is useless.
		panel = { enabled = false },
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = "<Tab>",
				dismiss = "<Esc>",
			},
		},
		-- Disable copilot in certain filetypes
		filetypes = {
			markdown = true,
			yaml = false,
			help = false,
			gitcommit = false,
			gitrebase = false,
			hgcommit = false,
			svn = false,
			cvs = false,
			["."] = false,
		},
	},
}
