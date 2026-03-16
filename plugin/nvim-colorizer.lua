vim.pack.add({
  "https://github.com/catgoose/nvim-colorizer.lua"
})

require("colorizer").setup({
  options = {
    parsers = { css_fn = true },
    display = {
      mode = "virtualtext",
      virtualtext = { position = "after" },
    },
  },
  filetypes = {
    "html",
    "css",
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "lua",
  },

})
