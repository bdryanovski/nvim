return {
	"rasulomaroff/cursor.nvim",
	event = "VeryLazy",
	opts = {
		overwrite_cursor = false,
		cursors = {
			{
				mode = "a",
				shape = "ver",
				size = 100,
				blink = { wait = 100, default = 400 },
			},
			{
				mode = "n",
				shape = "block",
			},
		},
		trigger = {
			strategy = nil,
			cursors = nil,
		},
	},
}
