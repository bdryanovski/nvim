local M = {}

local config = {
	pairs = {
		{ "true", "false" },
		{ "True", "False" },
		{ "TRUE", "FALSE" },
		{ "yes", "no" },
		{ "Yes", "No" },
		{ "YES", "NO" },
		{ "on", "off" },
		{ "On", "Off" },
		{ "ON", "OFF" },
		{ "and", "or" },
		{ "And", "Or" },
		{ "AND", "OR" },
	},
	keymap = "<leader>tw", -- Default keymap
}

function M.toggle_word()
	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, cursor_row - 1, cursor_row, true)[1]

	local cword = vim.fn.expand("<cword>")

	-- Find the word under the cursor
	-- We need to find the exact start and end of the cword in the line
	-- string.find returns start and end byte indices, not character indices for multi-byte characters.
	-- For simple ASCII words, this should be fine.
	local word_start, word_end = line:find(cword, 1, true)

	if not word_start then
		return
	end

	local current_word = line:sub(word_start, word_end)
	for _, pair in ipairs(config.pairs) do
		if current_word == pair[1] then
			vim.api.nvim_buf_set_text(0, cursor_row - 1, word_start - 1, cursor_row - 1, word_end, { pair[2] })
			return
		elseif current_word == pair[2] then
			vim.api.nvim_buf_set_text(0, cursor_row - 1, word_start - 1, cursor_row - 1, word_end, { pair[1] })
			return
		end
	end
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	if config.keymap then
		vim.keymap.set("n", config.keymap, M.toggle_word, { desc = "Toggle word" })
	end
end

return M
