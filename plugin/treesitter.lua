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
