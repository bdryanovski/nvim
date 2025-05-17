return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"hrsh7th/cmp-nvim-lsp",
		"ibhagwan/fzf-lua",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local navic = require("nvim-navic")
		local fzf_lua = require("fzf-lua")

		local util = require("lspconfig.util")

		local on_attach = function(client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
		end

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
				map("<leader>D", fzf_lua.diagnostics_document, "Show buffer/file diagnostics")
				map("<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
				map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
				map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")

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
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
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
				if
					client
					and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local original_capabilities = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

		local lsp_flags = {
			debounce_text_changes = 150,
		}

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			flags = lsp_flags,
			server = {
				settings = {
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
		})

		-- lspconfig["eslint"].setup({
		-- 	capabilities = capabilities,
		-- 	root_dir = function(fname)
		-- 		local root =
		-- 			util.root_pattern(".eslintrc.js", ".eslintrc.json", "eslint.config.js", "package.json")(fname)
		-- 		if root then
		-- 			return root
		-- 		end
		-- 		return nil -- don’t start if no config found
		-- 	end,
		-- })

		-- ESLint with diagnostics disabled
		lspconfig["eslint"].setup({
			capabilities = capabilities,
			root_dir = function(fname)
				-- Find the closest ESLint configuration
				local eslint_config_pattern = util.root_pattern(
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.mjs"
				)

				-- Used to store path segments
				local path_segments = {}
				local path = fname

				-- Build up segments of the path
				while path ~= nil and path ~= "" do
					table.insert(path_segments, path)
					path = vim.fn.fnamemodify(path, ":h")
					if path == "/" then
						table.insert(path_segments, path)
						break
					end
				end

				-- Check each path segment for ESLint config, starting from the most specific
				for _, path_segment in ipairs(path_segments) do
					local config_path = eslint_config_pattern(path_segment)
					if config_path then
						return config_path
					end
				end

				-- Fall back to project markers if no ESLint config found
				return util.root_pattern(".git", "package.json", "tsconfig.json", "jsconfig.json")(fname)
			end,
			-- on_attach = function(client, bufnr)
			-- 	-- Explicitly disable diagnostics for ESLint
			-- 	client.server_capabilities.diagnosticProvider = false
			--
			-- 	-- This means textDocument/diagnostic requests will be ignored
			-- 	if client.supports_method and client.supports_method("textDocument/diagnostic") then
			-- 		client.server_capabilities.textDocumentSync = {
			-- 			openClose = true,
			-- 			change = 2,
			-- 			willSave = true,
			-- 			willSaveWaitUntil = false,
			-- 			save = { includeText = false },
			-- 		}
			-- 	end
			-- end,
			handlers = {
				-- Handle textDocument/diagnostic requests with no-op function
				["textDocument/diagnostic"] = function()
					return nil
				end,
			},
			settings = {
				useESLintClass = true,
				experimental = {
					useFlatConfig = true,
				},
				workingDirectories = { mode = "closest" },
				-- Disable running diagnostics
				run = "never",
			},
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
		})

		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			settings = { -- custom settings for lua
				Lua = {
					completion = {
						workspaceWord = true,
						callSnippet = "Both",
					},
					misc = {
						parameters = {
							-- "--log-level=trace",
						},
					},
					hint = {
						enable = true,
						setType = false,
						paramType = true,
						paramName = "Disable",
						semicolon = "Disable",
						arrayIndex = "Disable",
					},
					doc = {
						privateName = { "^_" },
					},
					type = {
						castNumberToInteger = true,
					},
					diagnostics = {

						globals = { "vim" },
						disable = { "incomplete-signature-doc", "trailing-space" },
						-- enable = false,
						groupSeverity = {
							strong = "Warning",
							strict = "Warning",
						},
						groupFileStatus = {
							["ambiguity"] = "Opened",
							["await"] = "Opened",
							["codestyle"] = "None",
							["duplicate"] = "Opened",
							["global"] = "Opened",
							["luadoc"] = "Opened",
							["redefined"] = "Opened",
							["strict"] = "Opened",
							["strong"] = "Opened",
							["type-check"] = "Opened",
							["unbalanced"] = "Opened",
							["unused"] = "Opened",
						},
						unusedLocalExclude = { "_*" },
					},
					format = {
						enable = false,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
							continuation_indent_size = "2",
						},
					},
					workspace = {
						checkThirdParty = false,
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- Add a diagnostic command to see what's handling textDocument/diagnostic
		vim.api.nvim_create_user_command("LspDiagHandler", function()
			print("Checking handlers for textDocument/diagnostic...")
			local clients = vim.lsp.get_active_clients()

			for _, client in ipairs(clients) do
				local supports_diagnostics = client.supports_method
					and client.supports_method("textDocument/diagnostic")

				print(
					string.format(
						"%s (id: %d): supports textDocument/diagnostic = %s",
						client.name,
						client.id,
						tostring(supports_diagnostics or false)
					)
				)

				if client.name == "eslint" or client.name:match("eslint") then
					print("ESLint config details:")
					print("  Root dir: " .. (client.config.root_dir or "N/A"))
					vim.print(client.config.settings or {})
				end
			end
		end, {})
	end,
}
