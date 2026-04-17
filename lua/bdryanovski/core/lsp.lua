-- Configuration for Neovim's built-in LSP client.
--
-- This file enables language servers, sets global diagnostic behaviour and
-- wires up buffer-local LSP keymaps and features on `LspAttach`.

-- Defer LSP configuration until after plugins are loaded.
-- This is necessary because vim.pack loads plugins after init.lua runs.
vim.schedule(function()
  -- Register all language servers to be managed by Neovim's LSP client.
  vim.lsp.enable({
    -- Lua LSP server for Neovim configuration
    'lua_ls',

    -- Web development LSP servers for JavaScript, TypeScript, CSS, HTML, and Astro
    'typescript-language-server',
    'cssls',
    'html',
    'astro_ls',

    -- Biome: formatting + linting for JS/TS/TSX projects that have biome.json(c)
    -- Only activates when a biome.json or biome.jsonc is found at the project root.
    -- Handles format-on-save automatically (see lsp/biome.lua).
    'biome',

    -- Rust LSP server for Rust development
    'rust_analyzer',

    -- Go LSP server for Go development
    'gopls',

    -- PHP LSP servers for PHP development
    'intelephense',
    'phpactor',

    -- CLangd for C/C++ development
    'clangd',

    -- oxfmt / oxlint for JS/TS linting & formatting
    'oxfmt',
    'oxlint',
  })

  local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()

  vim.lsp.config('*', {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    root_markets = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' },
  })
end)

-- Global diagnostics configuration: how errors/warnings/hints are displayed.
vim.diagnostic.config({
  -- virtual_lines = {
  -- 	current_line = true, -- Show virtual lines only on the current line
  -- 	severity = {
  -- 		min = vim.diagnostic.severity.ERROR, -- Show diagnostics with severity ERROR and above
  -- 	},
  -- },
  underline = true,
  update_in_insert = false, -- Do not update diagnostics while typing.
  severity_sort = true, -- Sort diagnostics by severity (errors first).
  virtual_text = false, -- Disable inline virtual text; rely on signs and floats.
  -- virtual_text = {
  -- 	prefix = "●", -- Could be '●', '▎', 'x'
  -- 	spacing = 4,
  -- },
  float = {
    -- source = "if_many", -- Or "if_many", "always"
    border = 'rounded',
    source = true, -- Show which source (LSP/diagnostic) produced the message.
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

-- Make sure that LSP floating windows visually match the main Normal window.
local set_hl_for_floating_window = function()
  vim.api.nvim_set_hl(0, 'NormalFloat', {
    link = 'Normal',
  })
  vim.api.nvim_set_hl(0, 'FloatBorder', {
    bg = 'none',
  })
end

set_hl_for_floating_window()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  desc = 'Reset LSP float highlights after colorscheme changes',
  callback = set_hl_for_floating_window,
})

-- Per-buffer LSP setup once a client attaches to a buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('setup-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Hover & signature help
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature help')

    -- Diagnostics for current line (uses global diagnostic config above).
    map('<leader>d', vim.diagnostic.open_float, 'Show line diagnostics')

    -- Toggle virtual diagnostic lines (requires plugin that honours virtual_lines).
    vim.keymap.set('n', 'gK', function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = 'Toggle diagnostic virtual_lines' })

    -- Helper to smooth over Neovim 0.10 vs 0.11 differences.
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has('nvim-0.11') == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    -- Highlight references of the word under the cursor while it is idle.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
      client
      and client_supports_method(
        client,
        vim.lsp.protocol.Methods.textDocument_documentHighlight,
        event.buf
      )
    then
      local highlight_augroup =
        vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
        end,
      })
    end

    -- Keymap to toggle inlay hints, if the server supports them.
    if
      client
      and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
    then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- vim.opt.completeopt = "menu,menuone,noselect,popup" -- Ensures the menu appears even for a single match and uses the native popup window.
-- vim.o.autocomplete = true -- Enables the overall completion feature.
--
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
-- 	callback = function(args)
-- 		local client_id = args.data.client_id
-- 		if not client_id then
-- 			return
-- 		end
--
-- 		local client = vim.lsp.get_client_by_id(client_id)
-- 		if client and client:supports_method("textDocument/completion") then
-- 			-- Enable native LSP completion for this client + buffer
-- 			vim.lsp.completion.enable(true, client_id, args.buf, {
-- 				autotrigger = true, -- auto-show menu as you type (recommended)
-- 				-- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
-- 			})
-- 		end
-- 	end,
-- })

-- Slightly higher updatetime here to reduce how often CursorHold fires while LSP works.
vim.opt.updatetime = 1000
-- Show errors and warnings in a floating window on CursorHold (alternative UX).
-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	callback = function()
-- 		vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
-- 	end,
-- })
