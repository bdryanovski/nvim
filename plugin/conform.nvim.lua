vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

local conform = require("conform")

local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

conform.setup({
  notify_on_error = false,
  formatters_by_ft = {
    json = function(bufnr)
      return { first(bufnr, "prettier"), "oxfmt" }
    end,
    javascript = function(bufnr)
      return { first(bufnr, "prettier"), "oxfmt" }
    end,
    javascriptreact = function(bufnr)
      return { first(bufnr, "prettier"), "oxfmt" }
    end,
    typescript = function(bufnr)
      return { first(bufnr, "prettier"), "oxfmt" }
    end,
    typescriptreact = function(bufnr)
      return { first(bufnr, "prettier"), "oxfmt" }
    end,
    css = { "prettier" },
    html = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    mdx = { "prettier" },
    graphql = { "prettier" },
    lua = { "stylua" },
    astro = { "prettier" },
    go = { "gofmt" },
    -- For filetypes without a formatter:
    ["_"] = { "trim_whitespace", "trim_newlines" },
  },
  -- Set default options
  default_format_opts = {
    lsp_format = "fallback",
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
desc = "Disable autoformat-on-save",
bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
    desc = "Re-enable autoformat-on-save",
  })
