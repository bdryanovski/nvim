return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		-- Start auto-formatting by default (and disable with my ToggleFormat command).
		vim.g.autoformat = true 

		conform.setup({
			notify_on_error = false,
			formatters_by_ft = {
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				-- For filetypes without a formatter:
				["_"] = { "trim_whitespace", "trim_newlines" },
			},
			format_on_save = function()
				-- Don't format when minifiles is open, since that triggers the "confirm without
				-- synchronization" message.
				if vim.g.minifiles_active then
					return nil
				end

				-- Stop if we disabled auto-formatting.
				if not vim.g.autoformat then
					return nil
				end

				return {}
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
