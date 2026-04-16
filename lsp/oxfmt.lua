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
---
--- When no project-level `.oxfmtrc.json` is found, the fallback config from
--- `formatters/oxfmtrc.json` in this Neovim config is used automatically.

-- Oxfmt config files that signal "this project has its own formatting style".
local oxfmt_config_files = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }

-- Path to the fallback config shipped with this Neovim config.
local fallback_config = vim.fn.stdpath("config") .. "/formatters/oxfmtrc.json"

--- Check whether a project-level oxfmt (or prettier) config exists above `fname`.
--- Also checks for an "oxfmt" dependency in the nearest package.json.
---@param fname string
---@return string|nil root_dir  project root when a config is found
local function find_project_root(fname)
	-- Look for dedicated oxfmt config files
	local found = vim.fs.find(oxfmt_config_files, {
		path = vim.fs.dirname(fname),
		upward = true,
		stop = vim.env.HOME,
	})
	if #found > 0 then
		return vim.fs.dirname(found[1])
	end

	-- Check for "oxfmt" in the nearest package.json
	local pkgs = vim.fs.find("package.json", {
		path = vim.fs.dirname(fname),
		upward = true,
		stop = vim.env.HOME,
	})
	if #pkgs > 0 then
		local ok, decoded = pcall(vim.fn.json_decode, vim.fn.readfile(pkgs[1]))
		if ok and decoded then
			local sections = { decoded.scripts, decoded.dependencies, decoded.devDependencies }
			for _, section in ipairs(sections) do
				if section and section["oxfmt"] then
					return vim.fs.dirname(pkgs[1])
				end
			end
		end
	end

	return nil
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
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local project_root = find_project_root(fname)
		-- Fall back to the file's directory so the LSP starts even without a project config.
		on_dir(project_root or vim.fs.dirname(fname))
	end,
	before_init = function(init_params, config)
		local root = config.root_dir or ""
		local has_project_config = false
		for _, marker in ipairs(oxfmt_config_files) do
			if vim.uv.fs_stat(vim.fs.joinpath(root, marker)) then
				has_project_config = true
				break
			end
		end

		-- When no project config exists, point to the fallback.
		if not has_project_config then
			local init_options = config.init_options or {}
			init_options.settings = vim.tbl_extend("force", init_options.settings or {}, {
				configPath = fallback_config,
			})
			init_params.initializationOptions = init_options
		end
	end,
}
