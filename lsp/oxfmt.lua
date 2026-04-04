--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/formatter.html
---
--- `oxfmt` is a Prettier-compatible code formatter that supports multiple languages
--- including JavaScript, TypeScript, JSON, YAML, HTML, CSS, Markdown, and more.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxfmt
--- ```

--- Replicates lspconfig.util.insert_package_json without requiring lspconfig.
--- Adds "package.json" to `config_files` if the nearest package.json upward
--- from `fname` lists `field` in scripts, dependencies, or devDependencies.
local function insert_package_json(config_files, field, fname)
	local pkg = vim.fs.find("package.json", { path = vim.fs.dirname(fname), upward = true })[1]
	if pkg then
		local ok, decoded = pcall(vim.fn.json_decode, vim.fn.readfile(pkg))
		if ok and decoded then
			local sections = { decoded.scripts, decoded.dependencies, decoded.devDependencies }
			for _, section in ipairs(sections) do
				if section and section[field] then
					table.insert(config_files, "package.json")
					break
				end
			end
		end
	end
	return config_files
end

return {
	cmd = function(dispatchers, config)
		local cmd = "oxfmt"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/oxfmt"
		if local_cmd and vim.fn.executable(local_cmd) == 1 then
			cmd = local_cmd
		end
		return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"toml",
		"json",
		"jsonc",
		"json5",
		"yaml",
		"html",
		"vue",
		"handlebars",
		"css",
		"scss",
		"less",
		"graphql",
		"markdown",
	},
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)

		-- Oxfmt resolves configuration by walking upward and using the nearest config file
		-- to the file being processed. We therefore compute the root directory by locating
		-- the closest `.oxfmtrc.json` / `.oxfmtrc.jsonc` (or `package.json` fallback) above the buffer.
		local root_markers = insert_package_json({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, "oxfmt", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
	end,
}
