vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
})

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local ensure_installed = {
	"typescript-language-server",
	"html-lsp",
	"css-lsp",
	"lua-language-server",
	"prettier",
	"stylua",
	"eslint_d",
	"gopls",
	"rust-analyzer",
	"astro-language-server",
	"graphql-language-service-cli",
	"intelephense",
	"clangd",
	"oxlint",
}
--
vim.defer_fn(function()
	local mr = require("mason-registry")
	for _, name in ipairs(ensure_installed) do
		local ok, pkg = pcall(mr.get_package, name)
		if ok and not pkg:is_installed() then
			pkg:install()
		end
	end
end, 500)
--

require("nvim-treesitter").setup()

-- Ensure essential treesitter parsers are installed once.
-- A stamp file records the installed parser list; the install is skipped on
-- subsequent startups unless the list changes.
local ensure_parsers = { "vim", "lua", "c", "markdown", "markdown_inline", "vimdoc", "query", "regex", "bash" }

local stamp_path = vim.fn.stdpath("data") .. "/nvim_ts_parsers.stamp"
local sorted = vim.deepcopy(ensure_parsers)
table.sort(sorted)
local stamp_content = table.concat(sorted, ",")

local already_installed = false
local f = io.open(stamp_path, "r")
if f then
	already_installed = (f:read("*a") == stamp_content)
	f:close()
end

if not already_installed then
	require("nvim-treesitter").install(ensure_parsers)
	local wf = io.open(stamp_path, "w")
	if wf then
		wf:write(stamp_content)
		wf:close()
	end
end

require("treesitter-context").setup({
	enable = true,
	max_lines = 0,
	min_window_height = 0,
	line_numbers = true,
	multiline_threshold = 20,
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
	zindex = 20,
	on_attach = nil,
})

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})
vim.treesitter.language.register("markdown", "mdx")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "mdx",
	callback = function()
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		-- Enable treesitter highlighting and disable regex syntax
		pcall(vim.treesitter.start)
		-- Enable treesitter-based indentation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
