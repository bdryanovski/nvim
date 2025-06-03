return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
	},
	config = function()
		-- Add a diagnostic command to see what's handling textDocument/diagnostic
		vim.api.nvim_create_user_command("LspDiagHandler", function()
			print("Checking handlers for textDocument/diagnostic...")
			local clients = vim.lsp.get_active_clients()

			for _, client in ipairs(clients) do
				local supports_diagnostics = client.supports_method
					and client.supports_method("textDocument/diagnostic")

				print(
					string.format(
						"%s (id: %d): supports textDocument/diagnostic = %s",
						client.name,
						client.id,
						tostring(supports_diagnostics or false)
					)
				)

				if client.name == "eslint" or client.name:match("eslint") then
					print("ESLint config details:")
					print("  Root dir: " .. (client.config.root_dir or "N/A"))
					vim.print(client.config.settings or {})
				end
			end
		end, {})
	end,
}
