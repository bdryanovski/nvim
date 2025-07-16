local M = {}

local config = {
	sign = {
		text = "🔖",
		texthl = "DiagnosticHint",
		priority = 10,
	},
	keymaps = {
		toggle = "mb",
		next = "]b",
		prev = "[b",
		list = "<leader>bl",
	},
	persist = true,
	storage_file = vim.fn.stdpath("data") .. "/bookmarks.json",
}

local bookmarks = {}

local function save_bookmarks()
	if not config.persist then
		return
	end
	local serializable = {}
	for bufnr, lines in pairs(bookmarks) do
		local path = vim.api.nvim_buf_get_name(bufnr)
		if path and path ~= "" then
			serializable[path] = {}
			for line, _ in pairs(lines) do
				table.insert(serializable[path], line)
			end
		end
	end
	local json = vim.fn.json_encode(serializable)
	vim.fn.writefile({ json }, config.storage_file)
end

local function load_bookmarks()
	if not config.persist then
		return
	end
	local f = io.open(config.storage_file, "r")
	if not f then
		return
	end
	local content = f:read("*a")
	f:close()
	local data = vim.fn.json_decode(content)
	if not data then
		return
	end

	for path, lines in pairs(data) do
		if type(lines) == "table" and #lines > 0 then
			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = path,
				once = true,
				callback = function(args)
					local bufnr = args.buf
					bookmarks[bufnr] = bookmarks[bufnr] or {}
					for _, line in ipairs(lines) do
						bookmarks[bufnr][line] = true
						vim.fn.sign_place(line, "bookmark_ns", "BookmarkSign", bufnr, {
							lnum = line,
							priority = config.sign.priority,
						})
					end
				end,
			})
		end
	end
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	vim.fn.sign_define("BookmarkSign", {
		text = config.sign.text,
		texthl = config.sign.texthl,
		linehl = "",
		numhl = "",
	})

	if config.keymaps.toggle then
		vim.keymap.set("n", config.keymaps.toggle, M.toggle_bookmark, { desc = "Toggle bookmark" })
	end
	if config.keymaps.next then
		vim.keymap.set("n", config.keymaps.next, M.next, { desc = "Next bookmark" })
	end
	if config.keymaps.prev then
		vim.keymap.set("n", config.keymaps.prev, M.prev, { desc = "Previous bookmark" })
	end
	if config.keymaps.list then
		vim.keymap.set("n", config.keymaps.list, M.show_list, { desc = "List bookmarks" })
	end

	vim.api.nvim_create_autocmd("BufDelete", {
		callback = function(args)
			bookmarks[args.buf] = nil
		end,
	})

	vim.api.nvim_create_user_command("BookmarkNext", M.next, {})
	vim.api.nvim_create_user_command("BookmarkPrev", M.prev, {})
	vim.api.nvim_create_user_command("BookmarkList", M.show_list, {})
	vim.api.nvim_create_user_command("BookmarkClear", M.clear_current, {})
	vim.api.nvim_create_user_command("BookmarkClearAll", M.clear_all, {})

	load_bookmarks()
end

function M.toggle_bookmark()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]

	bookmarks[bufnr] = bookmarks[bufnr] or {}

	if bookmarks[bufnr][line] then
		vim.fn.sign_unplace("bookmark_ns", { buffer = bufnr, id = line })
		bookmarks[bufnr][line] = nil
	else
		vim.fn.sign_place(line, "bookmark_ns", "BookmarkSign", bufnr, {
			lnum = line,
			priority = config.sign.priority,
		})
		bookmarks[bufnr][line] = true
	end

	save_bookmarks()
end

function M.next()
	local bufnr = vim.api.nvim_get_current_buf()
	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = bookmarks[bufnr]
	if not lines then
		return
	end

	local sorted = {}
	for line in pairs(lines) do
		table.insert(sorted, line)
	end
	table.sort(sorted)

	for _, line in ipairs(sorted) do
		if line > cur_line then
			vim.api.nvim_win_set_cursor(0, { line, 0 })
			return
		end
	end
	if #sorted > 0 then
		vim.api.nvim_win_set_cursor(0, { sorted[1], 0 })
	end
end

function M.prev()
	local bufnr = vim.api.nvim_get_current_buf()
	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = bookmarks[bufnr]
	if not lines then
		return
	end

	local sorted = {}
	for line in pairs(lines) do
		table.insert(sorted, line)
	end
	table.sort(sorted, function(a, b)
		return a > b
	end)

	for _, line in ipairs(sorted) do
		if line < cur_line then
			vim.api.nvim_win_set_cursor(0, { line, 0 })
			return
		end
	end
	if #sorted > 0 then
		vim.api.nvim_win_set_cursor(0, { sorted[1], 0 })
	end
end

function M.show_list()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = bookmarks[bufnr]
	if not lines then
		return
	end

	local sorted = {}
	for line in pairs(lines) do
		table.insert(sorted, line)
	end
	table.sort(sorted)

	local content = {}
	local keymap = {}
	for i, line in ipairs(sorted) do
		local key = string.char(96 + i) -- 'a', 'b', 'c', ...
		local text = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
		content[i] = string.format("%s  %4d: %s", key, line, text)
		keymap[key] = line
	end

	local width = math.max(40, math.floor(vim.o.columns * 0.5))
	local height = math.min(#content + 2, 20)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local list_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, content)
	vim.api.nvim_buf_set_option(list_buf, "modifiable", false)

	local win_id = vim.api.nvim_open_win(list_buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "rounded",
		style = "minimal",
	})

	local function jump_and_close(line)
		vim.api.nvim_win_close(win_id, true)
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	end

	vim.keymap.set("n", "<CR>", function()
		local line_num = vim.api.nvim_win_get_cursor(win_id)[1]
		jump_and_close(sorted[line_num])
	end, { buffer = list_buf })

	for k, l in pairs(keymap) do
		vim.keymap.set("n", k, function()
			jump_and_close(l)
		end, { buffer = list_buf })
	end

	vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = list_buf })
end

-- Clear bookmarks in current buffer
function M.clear_current()
	local bufnr = vim.api.nvim_get_current_buf()
	bookmarks[bufnr] = nil
	save_bookmarks()
end

-- Clear all bookmarks in all buffers
function M.clear_all()
	bookmarks = {}
	save_bookmarks()
end

return M
