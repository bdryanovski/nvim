-- Custom Mapping
--
--
vim.g.mapleader = ","

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlights", silent = true })
keymap.set("n", "+", "<C-a>", { desc = "Increment number under the cursor", silent = true })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number under the cursor", silent = true })
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all", silent = true })
keymap.set("n", "H", "^", { desc = "Go to first non blank character", silent = true })
keymap.set(
	"x",
	"K",
	":move '<-2<CR>gv-gv",
	{ desc = "Move up selected line / block of text in visual mode", silent = true }
)
keymap.set(
	"x",
	"J",
	":move '>+1<CR>gv-gv",
	{ desc = "Move down selected line / block of text in visual mode", silent = true }
)

-- Tabs and tab navigation
keymap.set("n", "<leader>te", ":tabedit", { desc = "Create new tab", silent = true })
keymap.set("n", "<tab>", ":tabnext<CR>", { desc = "Switch to next tab", silent = true })
keymap.set("n", "<s-tab>", ":tabprev<CR>", { desc = "Go to previous tab", silent = true })
keymap.set("n", "<C-w>", ":tabclose<Return>", { desc = "Close current tab", silent = true })
keymap.set("n", "<C-to>", ":tabonly<CR>", { desc = "Close all other tabs", noremap = true, silent = true })

-- Window managment
keymap.set("n", "<Space>", "<C-w>w", { desc = "Go to next window", remap = true })
keymap.set("", "s<left>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap.set("", "s<right>", "<C-w>l", { desc = "Go to right window", remap = true })
keymap.set("", "s<up>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap.set("", "s<down>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap.set("n", "ss", ":split<Return><C-w>w", { desc = "Split horizontally", silent = true })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { desc = "Split vertically", silent = true })
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

keymap.set("v", "<", "<gv", { desc = "Indent inner" })
keymap.set("v", ">", ">gv", { desc = "Indent outter" })

-- Too lazy to learn it
-- https://neovim.io/doc/user/api.html#nvim_create_user_command()
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})

keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Goto Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next({ popup_opts = { border = "rounded" } })
end, { desc = "Go to next diagnostic", silent = true })
