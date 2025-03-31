return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"hrsh7th/cmp-nvim-lsp",
		{ "weilbith/nvim-code-action-menu" },
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local navic = require("nvim-navic")

		-- import cmp-nvim-lsp plugin
		-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
		--
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("setup-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gD", vim.lsp.buf.declaration, "Go to declaration")
				map("gd", vim.lsp.buf.definition, "Go to definition")
				map("K", vim.lsp.buf.hover, "Hover documentation")
				map("gi", vim.lsp.buf.implementation, "Go to implementation")
				map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

				map("gr", vim.lsp.buf.references, "Show LSP references")
				map("rn", vim.lsp.buf.rename, "Smart rename")
				map("<leader>ca", "<cmd>CodeActionMenu<CR>", "See available code actions", { "n", "v" })
				map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer/file diagnostics")
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
				--
				-- This may be unwanted, since they displace some of your code
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

		-- local keymap = vim.keymap -- for conciseness
		--
		-- local opts = { noremap = true, silent = true }
		-- local on_attach = function(client, bufnr)
		-- 	if client.server_capabilities.documentSymbolProvider then
		-- 		navic.attach(client, bufnr)
		-- 	end
		--
		-- 	opts.buffer = bufnr
		--
		-- 	-- set keybinds
		-- 	opts.desc = "Show LSP references"
		-- 	keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
		--
		-- 	-- opts.desc = "Go to declaration"
		-- 	-- keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
		-- 	--
		-- 	-- opts.desc = "Show LSP definitions"
		-- 	-- keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
		-- 	-- --
		-- 	-- opts.desc = "Show LSP implementations"
		-- 	-- keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
		-- 	--
		-- 	opts.desc = "Show LSP type definitions"
		-- 	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
		--
		-- 	opts.desc = "See available code actions"
		-- 	-- keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
		--
		-- 	keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeActionMenu<CR>", opts) -- see available code actions, in visual mode will apply to selection
		--
		-- 	opts.desc = "Smart rename"
		-- 	keymap.set("n", "<leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts) -- smart rename

		-- 	opts.desc = "Show buffer diagnostics"
		-- 	keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
		--
		-- 	opts.desc = "Show line diagnostics"
		-- 	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
		--
		-- 	opts.desc = "Go to previous diagnostic"
		-- 	keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
		--
		-- 	opts.desc = "Go to next diagnostic"
		-- 	keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
		--
		-- 	opts.desc = "Show documentation for what is under cursor"
		-- 	keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
		--
		-- 	opts.desc = "Restart LSP"
		-- 	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		-- end
		--
		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()
		local original_capabilities = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

		-- capabilities.textDocument.foldingRange = {
		-- 	dynamicRegistration = false,
		-- 	lineFoldingOnly = true,
		-- }
		--
		-- -- Code actions
		-- vim.g.code_action_menu_show_details = false
		-- vim.g.code_action_menu_show_diff = true
		-- vim.g.code_action_menu_show_action_kind = false

		-- capabilities.textDocument.codeAction = {
		-- 	dynamicRegistration = false,
		-- 	codeActionLiteralSupport = {
		-- 		codeActionKind = {
		-- 			valueSet = {
		-- 				"",
		-- 				"quickfix",
		-- 				"refactor",
		-- 				"refactor.extract",
		-- 				"refactor.inline",
		-- 				"refactor.rewrite",
		-- 				"source",
		-- 				"source.organizeImports",
		-- 			},
		-- 		},
		-- 	},
		-- }

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end
		--
		local lsp_flags = {
			debounce_text_changes = 150,
		}

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
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

		lspconfig["eslint"].setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = true
				local function buf_set_option(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

				-- eslint fix on save
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
				format = true,
				nodePath = "",
				problems = {
					shortenToSingleLine = false,
				},
				quiet = false,
				rulesCustomizations = {},
				run = "onType",
				useESLintClass = false,
				validate = "on",
				workingDirectory = {
					mode = "location",
				},
			},
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
		})

		-- configure prisma orm server
		lspconfig["prismals"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
		})

		-- configure graphql language server
		lspconfig["graphql"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
			filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			-- on_attach = on_attach,
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
	end,
}
