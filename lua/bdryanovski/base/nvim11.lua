-- Neovim configuration file for setting up various options and preferences.
-- supporting only Neovim 0.11 and above

-- Check if the current version of Neovim is 0.11 or higher
--
if vim.fn.has("nvim-0.11") == 1 then
	vim.diagnostic.config({
		virtual_lines = {
			current_line = true,
		},
		virtual_text = false,
	})

	vim.keymap.set("n", "gK", function()
		vim.diagnostic.config({
			virtual_lines = not vim.diagnostic.config().virtual_lines,
		})
	end, { desc = "Toggle diagnostic virtual_lines" })
end
