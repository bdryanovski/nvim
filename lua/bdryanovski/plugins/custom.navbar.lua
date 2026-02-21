return {
	dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/navbar",
	name = "navbar",
	main = "bdryanovski/custom/navbar",
	event = "BufReadPost",
	config = function()
		require("bdryanovski/custom/navbar")

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = vim.api.nvim_create_augroup("bdryanovski/navbar", { clear = true }),
			desc = "Attach winbar",
			callback = function(args)
				if
					not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
					and vim.bo[args.buf].buftype == "" -- Normal buffer
					and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
					and not vim.wo[0].diff -- Not in diff mode
				then
					vim.wo.winbar = "%{%v:lua.require('bdryanovski/custom/navbar').render()%}"
				end
			end,
		})
	end,
}
