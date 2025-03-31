return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "buffers",
			themable = true,
			numbers = "buffer_id",
			separator_style = "slant",
			always_show_bufferline = true,
			show_buffer_close_icons = true,
			show_close_icon = false,
			color_icons = true,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
		},
	},
}
