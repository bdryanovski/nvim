return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	config = function()
		local fzf = require("fzf-lua")

		-- Setup default options
		fzf.setup({
			-- Global options
			global_resume = true, -- enable global `resume`
			global_resume_query = true, -- include query in `resume`
			winopts = {
				height = 0.85, -- window height
				width = 0.80, -- window width
				border = "rounded", -- window border type
				backdrop = 20,
				preview = {
					border = "rounded", -- preview border type
					layout = "vertical", -- vertical preview layout
					scrollbar = "float", -- preview scrollbar type
					delay = 50, -- delay(ms) displaying the preview
					title = true, -- preview window title
					title_pos = "center", -- alignment of preview window title
					scrollchars = { "█", "" }, -- scrollbar chars
					winopts = { -- builtin previewer window options
						number = true,
						relativenumber = false,
						cursorline = true,
						cursorlineopt = "both",
						cursorcolumn = false,
						signcolumn = "no",
						list = false,
						foldenable = false,
						foldmethod = "manual",
					},
				},
				on_create = function()
					-- Disable line wrap and line number in preview window
					vim.cmd("set nowrap")
					vim.cmd("set nonumber")
				end,
			},
			keymap = {
				-- These override the default tables completely
				builtin = {
					-- neovim `:tmap` mappings for the fzf win
					["<A-k>"] = "toggle-preview-wrap",
					["<A-h>"] = "toggle-preview",
					["<A-/>"] = "toggle-help",
					["<A-p>"] = "toggle-preview",
					["<A-d>"] = "preview-page-down",
					["<A-u>"] = "preview-page-up",
				},
				fzf = {
					-- fzf '--bind=' options
					["alt-a"] = "toggle-all",
					["alt-enter"] = "toggle+down",
					["alt-w"] = "toggle-preview-wrap",
				},
			},
			previewers = {
				-- Add custom size logic
				builtin = {
					syntax = true,
				},
				git_diff = {
					pager = "delta",
				},
			},
			files = {
				previewers = "bat",
				prompt = "Files❯ ",
				git_icons = true, -- show git icons?
				file_icons = true, -- show file icons?
				color_icons = true, -- colorize file|git icons
				find_opts = [[-type f -not -path "*/\.git/*" -not -path "*/node_modules/*"]],
				rg_opts = "--color=never --files --hidden --follow -g '!{.git,node_modules}/*'",
				fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
			},
			buffers = {
				prompt = "Buffers❯ ",
				sort_lastused = true, -- sort buffers by last used
				actions = {
					-- actions inherit from 'actions.files' and merge
					["ctrl-d"] = function(selected)
						-- Delete selected buffer
						for _, s in ipairs(selected) do
							require("fzf-lua").actions.buf_del(s)
						end
					end,
				},
			},
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
				grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
			},
			lsp = {
				prompt = "❯ ",
				-- LSP specific options
				cwd_only = false, -- LSP/diagnostics for cwd only
				jump_to_single_result = true, -- automatically jump if only a single result is found
				symbols = {
					symbol_hl_prefix = "FzfLuaSymbol",
					symbol_style = 1, -- how symbols are displayed:
					-- 1: "AccountId [lsp.interface] interface.ts"
					-- 2: "AccountId (interface) [lsp.interface]"
				},
				code_actions = {
					previewer = "builtin", -- Use more compatible previewer
					-- Set to 'codeaction' to use specialized previewer or 'builtin' for generic previewer
					prompt = "Code Actions> ",
					no_preview_msg = "Preview not available for this action",
					preview_only_utf8 = true,
					dynamic_preview = false,
					path_shorten = false, -- Don't shorten path to improve compatibility
					check_preview_win = function(winnr)
						-- Fix for paths with spaces and special characters
						return true -- Skip the preview window check
					end,
					action_on_accept = function(action, code_action)
						-- Some TypeScript refactorings don't have a preview but can still be applied
						if action and not code_action.preview then
							return true -- Apply the action even without preview
						end
						-- Handle special paths like the one in the error
						if action and action.edit and action.edit.documentChanges then
							for _, change in ipairs(action.edit.documentChanges) do
								if change.textDocument and change.textDocument.uri then
									-- Ensure URI is properly handled
									local uri = change.textDocument.uri
									-- Skip preview for certain URIs that might cause issues
									if uri:match("%s") or uri:match("%[") or uri:match("%]") then
										return true -- Apply without preview for problematic URIs
									end
								end
							end
						end
						return false -- Default behavior for other actions
					end,
				},
			},
			diagnostics = {
				prompt = "Diagnostics❯ ",
				cwd_only = false, -- LSP diagnostics for cwd only
				file_icons = true, -- show file icons in diagnostics
				git_icons = false, -- show git icons in diagnostics
				diag_icons = true, -- show diagnostics icons in results
				icon_padding = "", -- space between icon and filename
				multiline = true, -- render multi-line messages
				preview_height = 0.65, -- preview window height as proportion
				signs = {
					["Error"] = { text = "E", texthl = "DiagnosticError" },
					["Warn"] = { text = "W", texthl = "DiagnosticWarn" },
					["Info"] = { text = "I", texthl = "DiagnosticInfo" },
					["Hint"] = { text = "H", texthl = "DiagnosticHint" },
				},
			},
		})

		-- Keymappings
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Files and buffers
		keymap("n", "<leader>ff", fzf.files, { desc = "Find files" })
		keymap("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
		keymap("n", "<leader>f/", fzf.oldfiles, { desc = "Find recent files" })
		keymap("n", "<leader>fr", fzf.resume, { desc = "Resume last search" })

		-- Search
		keymap("n", "<leader>fs", fzf.live_grep, { desc = "Search with grep" })
		keymap("n", "<leader>fc", fzf.grep_cword, { desc = "Search word under cursor" })
		keymap("v", "<leader>fv", fzf.grep_visual, { desc = "Search visual selection" })

		-- LSP related
		keymap("n", "<leader>lr", fzf.lsp_references, { desc = "LSP references" })
		keymap("n", "<leader>ld", fzf.lsp_definitions, { desc = "LSP definitions" })
		keymap("n", "<leader>li", fzf.lsp_implementations, { desc = "LSP implementations" })
		keymap("n", "<leader>lt", fzf.lsp_typedefs, { desc = "LSP type definitions" })
		keymap("n", "<leader>ls", fzf.lsp_document_symbols, { desc = "LSP document symbols" })
		keymap("n", "<leader>lw", fzf.lsp_workspace_symbols, { desc = "LSP workspace symbols" })
		keymap("n", "<leader>la", fzf.lsp_code_actions, { desc = "LSP code actions" })

		-- Diagnostics
		keymap("n", "<leader>dd", fzf.diagnostics_document, { desc = "Document diagnostics" })
		keymap("n", "<leader>dw", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })

		-- Git
		keymap("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
		keymap("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
		keymap("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
	end,
}
