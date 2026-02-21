return {
	dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/peacock",
	name = "peacock",
	main = "bdryanovski/custom/peacock",
	event = "BufReadPost",
	config = function()
		require("bdryanovski/custom/peacock").setup({
			bar_enabled = false, -- When this is enabled (default) the left most window will show its signcolumn with the project color.
			sign_column_width = 1, -- This is the width of the bar sowhing in the left most window.
			eob_enabled = true, -- To give a more unified look we set the eob character to █ and color it to the project color
		})

		local nvim_set_hl = vim.api.nvim_set_hl
		-- Apply Peacock color to other UI components
		nvim_set_hl(0, "WinSeparator", { link = "PeacockFg" })
		nvim_set_hl(0, "FloatBorder", { link = "PeacockFg" })
		nvim_set_hl(0, "LineNr", { link = "PeacockFg" })
	end,
}
