return {
	"rasulomaroff/cursor.nvim",
	event = "VeryLazy",
	opts = {
		overwrite_cursor = true,
		cursors = {
			{
				mode = "a",
				shape = "ver",
				size = 100,
				blink = { wait = 100, default = 400 },
			},
		},
		trigger = {
			strategy = nil,
			cursors = nil,
		},
	},
}
