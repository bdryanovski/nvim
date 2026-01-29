return {
	"b0o/incline.nvim",
	dependencies = {},
	event = "BufReadPre",
	priority = 1200,
	config = function()
		local devicons = require("nvim-web-devicons")
		local helpers = require("incline.helpers")
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			hide = { cursorline = true, focused_win = true },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)

				local res = {
					ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
					{ " " .. filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
				}

				table.insert(res, " ")

				return res
			end,
		})
	end,
}
