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

-- Prettier config files that signal "this project has its own style".
local prettier_config_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

--- Check whether the buffer's project already has a prettier config.
--- Walks up from the file's directory looking for config files or a
--- "prettier" key in the nearest package.json.
---@param bufnr integer
---@return boolean
local function has_project_prettier_config(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return false
  end

  -- Look for dedicated config files
  local found = vim.fs.find(prettier_config_files, {
    upward = true,
    path = vim.fs.dirname(bufname),
    stop = vim.env.HOME,
  })
  if #found > 0 then
    return true
  end

  -- Check for "prettier" key in the nearest package.json
  local pkgs = vim.fs.find("package.json", {
    upward = true,
    path = vim.fs.dirname(bufname),
    stop = vim.env.HOME,
  })
  if #pkgs > 0 then
    local ok, text = pcall(vim.fn.readfile, pkgs[1])
    if ok then
      local json_ok, data = pcall(vim.json.decode, table.concat(text, "\n"))
      if json_ok and type(data) == "table" and data.prettier ~= nil then
        return true
      end
    end
  end

  return false
end

-- Oxfmt config files that signal "this project has its own formatting style".
local oxfmt_config_files = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }

--- Check whether the buffer's project already has an oxfmt config.
---@param bufnr integer
---@return boolean
local function has_project_oxfmt_config(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return false
  end

  local found = vim.fs.find(oxfmt_config_files, {
    upward = true,
    path = vim.fs.dirname(bufname),
    stop = vim.env.HOME,
  })
  return #found > 0
end

-- Paths to the fallback configs shipped with this Neovim config.
local fallback_prettierrc = vim.fn.stdpath("config") .. "/formatters/prettierrc.json"
local fallback_oxfmtrc = vim.fn.stdpath("config") .. "/formatters/oxfmtrc.json"

conform.setup({
  notify_on_error = false,
  ---@type table<string, conform.FormatterConfigOverride>
  formatters = {
    prettier = {
      prepend_args = function(_, ctx)
        if not has_project_prettier_config(ctx.buf) then
          return { "--config", fallback_prettierrc }
        end
        return {}
      end,
    },
    oxfmt = {
      prepend_args = function(_, ctx)
        if not has_project_oxfmt_config(ctx.buf) then
          return { "--config", fallback_oxfmtrc }
        end
        return {}
      end,
    },
  },
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
