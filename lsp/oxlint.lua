--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/linter.html
---
--- `oxlint` is a linter for JavaScript / TypeScript supporting over 500 rules from ESLint and its popular plugins.
--- It also supports linting framework files (Vue, Svelte, Astro) by analyzing their <script> blocks.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxlint
--- ```
---
--- Type-aware linting will automatically be enabled if `tsgolint` exists in your
--- path and your `.oxlintrc.json` contains the string "typescript".
---
--- When no project-level `.oxlintrc.json` is found, the fallback config from
--- `formatters/oxlintrc.json` in this Neovim config is used automatically.
---
--- The default `on_attach` function provides an `:LspOxlintFixAll` command which
--- can be used to fix all fixable diagnostics. See the `eslint` config entry for
--- an example of how to use this to automatically fix all errors on write.

-- Oxlint config files that signal "this project has its own lint rules".
local oxlint_config_files = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }

-- Path to the fallback config shipped with this Neovim config.
local fallback_config = vim.fn.stdpath("config") .. "/formatters/oxlintrc.json"

local function oxlint_conf_mentions_typescript(root_dir)
	for _, marker in ipairs(oxlint_config_files) do
		local fn = vim.fs.joinpath(root_dir, marker)
		local f = io.open(fn, "r")
		if f then
			local content = f:read("*a")
			f:close()
			if content and content:find("typescript") then
				return true
			end
		end
	end
	return false
end

--- Check whether a project-level oxlint config exists above `fname`.
---@param fname string
---@return string|nil root_dir  project root when a config is found
local function find_project_root(fname)
	local found = vim.fs.find(oxlint_config_files, {
		path = vim.fs.dirname(fname),
		upward = true,
		stop = vim.env.HOME,
	})
	if #found > 0 then
		return vim.fs.dirname(found[1])
	end
	return nil
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local cmd = "oxlint"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/oxlint"
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
		"vue",
		"svelte",
		"astro",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local project_root = find_project_root(fname)
		-- Fall back to the file's directory so the LSP starts even without a project config.
		on_dir(project_root or vim.fs.dirname(fname))
	end,
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
			client:exec_cmd({
				title = "Apply Oxlint automatic fixes",
				command = "oxc.fixAll",
				arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
			})
		end, {
			desc = "Apply Oxlint automatic fixes",
		})
	end,
	before_init = function(init_params, config)
		local root = config.root_dir or ""
		local settings = config.settings or {}

		-- Detect whether a project config exists at the resolved root.
		local has_project_config = false
		for _, marker in ipairs(oxlint_config_files) do
			if vim.uv.fs_stat(vim.fs.joinpath(root, marker)) then
				has_project_config = true
				break
			end
		end

		-- When no project config exists, point to the fallback.
		if not has_project_config then
			settings = vim.tbl_extend("force", settings, {
				configPath = fallback_config,
			})
		end

		-- Auto-enable type-aware linting when possible.
		if settings.typeAware == nil and vim.fn.executable("tsgolint") == 1 then
			local ok, res = pcall(oxlint_conf_mentions_typescript, root)
			if ok and res then
				settings = vim.tbl_extend("force", settings, { typeAware = true })
			end
		end

		local init_options = config.init_options or {}
		init_options.settings = vim.tbl_extend("force", init_options.settings or {} --[[@as table]], settings)
		init_params.initializationOptions = init_options
	end,
}
