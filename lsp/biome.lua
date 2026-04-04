--- @brief
---
--- https://biomejs.dev
--- https://biomejs.dev/guides/editors/create-an-extension/
---
--- Biome LSP proxy — handles formatting AND linting for JS/TS/TSX files.
---
--- Biome is resolved in this order:
---   1. Local project binary: node_modules/.bin/biome  (preferred — uses project's version)
---   2. Falls back to a globally installed `biome` binary
---
--- The project MUST have a biome.json or biome.jsonc at its root.
--- Without a config file Biome will not start for this project.

return {
  cmd = function(dispatchers, config)
    -- Prefer the project-local binary so the LSP uses the exact same version
    -- as `bun run lint` / `bun run format` in the terminal.
    local local_bin = (config and config.root_dir)
        and vim.fs.joinpath(config.root_dir, "node_modules", ".bin", "biome")
      or nil

    local cmd
    if local_bin and vim.fn.executable(local_bin) == 1 then
      cmd = local_bin
    elseif vim.fn.executable("biome") == 1 then
      cmd = "biome"
    else
      vim.notify(
        "biome: no binary found. Install globally (`npm i -g @biomejs/biome`) "
          .. "or add it to devDependencies and run `bun install`.",
        vim.log.levels.WARN
      )
      return nil
    end

    return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  end,

  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
  },

  -- Only activate when a biome config is present at the workspace root.
  root_markers = { "biome.json", "biome.jsonc" },

  -- Biome requires a workspace root to resolve its config file.
  workspace_required = true,

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      vim.fs.dirname(
        vim.fs.find({ "biome.json", "biome.jsonc" }, { path = fname, upward = true })[1]
      )
    )
  end,

  -- Tell Biome to handle formatting so we can use vim.lsp.buf.format()
  -- and format-on-save via the LspAttach autocmd.
  capabilities = {
    textDocument = {
      formatting = { dynamicRegistration = false },
      rangeFormatting = { dynamicRegistration = false },
    },
  },

  on_attach = function(client, bufnr)
    -- Format-on-save for TypeScript/TSX files using Biome as the formatter.
    -- Uses only Biome (not ts_ls) to avoid conflicts.
    local biome_fts = {
      typescript = true,
      typescriptreact = true,
      javascript = true,
      javascriptreact = true,
    }

    local ft = vim.bo[bufnr].filetype
    if biome_fts[ft] then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = vim.api.nvim_create_augroup("biome-format-on-save-" .. bufnr, { clear = true }),
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            -- Use ONLY biome for formatting; exclude ts_ls which also offers formatting
            filter = function(c)
              return c.name == "biome"
            end,
            timeout_ms = 3000,
          })
        end,
      })
    end
  end,
}

