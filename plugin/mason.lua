
vim.pack.add({
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
})

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- enable mason and configure icons
mason.setup({
  ui = {
    border = "rounded",
    backdrop = 20,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  automatic_enable = false,
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "lua_ls",
    "gopls",
    "rust_analyzer",
    "astro",
    "graphql",
    "intelephense",
    "clangd",
  },
  automatic_installation = true, -- not the same as ensure_installed
})
