return {
	"Sebastian-Nielsen/better-type-hover",
	ft = { "typescript", "typescriptreact" },
	config = function()
		require("better-type-hover").setup()

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
			vim.lsp.handlers.hover,
			{} -- e.g. { border = "rounded" }
		)
	end,
}
