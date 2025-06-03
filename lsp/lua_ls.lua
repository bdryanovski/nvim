return {
	cmd = {
		"lua-language-server",
	},
	filetypes = {
		"lua",
	},
	root_markers = {
		".git",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"selene.toml",
		"selene.yml",
		"stylua.toml",
	},
	single_file_support = true,
	log_level = vim.lsp.protocol.MessageType.Warning,
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
}
