-- Global autocommands for quality-of-life behaviour.
-- Loaded from `init.lua` after core options.
local function augroup(name)
	return vim.api.nvim_create_augroup("bdryanovski_" .. name, { clear = true })
end

-- Highlight text briefly after yanking, to give visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- When the terminal window is resized, equalize all splits in all tabs.
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Jump back to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_location"),
	desc = "Go to the last location when opening a buffer",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

-- For commit messages and markdown, enforce textwidth and enable spell checking.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown", "mdx" },
	callback = function()
		vim.opt_local.textwidth = 100
		vim.opt_local.wrap = false
		vim.opt_local.spell = true
	end,
})

-- Automatically create missing directories before writing a file to disk.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		-- Skip URIs like oil://, http:// etc.
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Keep buffers in sync with changes on disk.
-- `autoread` tells Neovim to check for external modifications, and the
-- autocommand triggers `:checktime` on common idle/focus events.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
