-- Configuration for Neovim's built-in LSP client
-- Require this file in your init.lua or wherever you configure Neovim
--
--

vim.lsp.enable({
	"lua_ls",
	"cssls",
	"html",
	"ts_ls",
	"rust_analyzer",
	"gopls",
	"astro_ls",
	"intelephense",
	"phpactor",
})

-- Workaround: ts_ls doesn't auto-start via vim.lsp.enable on Neovim 0.12+
-- This uses the config already loaded above from lsp/ts_ls.lua
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("ts_ls-start", { clear = true }),
	pattern = vim.lsp.config.ts_ls.filetypes,
	callback = function(args)
		local cfg = vim.lsp.config.ts_ls
		local root = vim.fs.root(args.buf, cfg.root_markers) or vim.fn.getcwd()
		vim.lsp.start(vim.tbl_extend("force", cfg, { name = "ts_ls", root_dir = root }))
	end,
})

vim.diagnostic.config({
	-- virtual_lines = {
	-- 	current_line = true, -- Show virtual lines only on the current line
	-- 	severity = {
	-- 		min = vim.diagnostic.severity.ERROR, -- Show diagnostics with severity ERROR and above
	-- 	},
	-- },
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	-- virtual_text = {
	-- 	prefix = "●", -- Could be '●', '▎', 'x'
	-- 	spacing = 4,
	-- },
	float = {
		-- source = "if_many", -- Or "if_many", "always"
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Help tiny inline diagnostics plugin to work with Neovim's built-in LSP client
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
})

-- Make sure that the LSP float window has the same background as the Normal window
-- or also known as the Theme Window background.
local set_hl_for_floating_window = function()
	vim.api.nvim_set_hl(0, "NormalFloat", {
		link = "Normal",
	})
	vim.api.nvim_set_hl(0, "FloatBorder", {
		bg = "none",
	})
end

set_hl_for_floating_window()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	desc = "Avoid overwritten by loading color schemes later",
	callback = set_hl_for_floating_window,
})
-- end of theme window background

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("setup-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("K", vim.lsp.buf.hover, "Hover documentation")
		map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

		-- Use fzf-lua for code actions
		map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")

		-- Some configrations for the LSP client
		vim.keymap.set("n", "gK", function()
			local new_config = not vim.diagnostic.config().virtual_lines
			vim.diagnostic.config({ virtual_lines = new_config })
		end, { desc = "Toggle diagnostic virtual_lines" })

		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
		---@param client vim.lsp.Client
		---@param method vim.lsp.protocol.Method
		---@param bufnr? integer some lsp support methods only in specific files
		---@return boolean
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

vim.opt.updatetime = 1000
-- Show errors and warnings in a floating window
-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	callback = function()
-- 		vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
-- 	end,
-- })
