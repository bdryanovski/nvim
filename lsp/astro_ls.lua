--- Find TypeScript SDK path by searching up from the given directory
---@param start_dir string|nil
---@return string|nil
local function find_typescript_sdk(start_dir)
	local search_dirs = {
		start_dir,
		vim.fn.getcwd(),
	}

	for _, dir in ipairs(search_dirs) do
		if dir then
			local ts_path = vim.fs.find("node_modules/typescript/lib", {
				path = dir,
				upward = true,
				type = "directory",
			})
			if ts_path and #ts_path > 0 then
				return ts_path[1]
			end
		end
	end

	-- Fallback: try to find global TypeScript installation
	local global_ts = vim.fn.exepath("tsc")
	if global_ts and global_ts ~= "" then
		local ts_lib = vim.fn.fnamemodify(global_ts, ":h:h") .. "/typescript/lib"
		if vim.fn.isdirectory(ts_lib) == 1 then
			return ts_lib
		end
	end

	return nil
end

return {
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	before_init = function(params, config)
		-- Set TypeScript SDK path before server initialization
		if not config.init_options then
			config.init_options = { typescript = {} }
		end
		if not config.init_options.typescript then
			config.init_options.typescript = {}
		end
		if not config.init_options.typescript.tsdk then
			local tsdk = find_typescript_sdk(config.root_dir or params.rootPath)
			if tsdk then
				config.init_options.typescript.tsdk = tsdk
			end
		end
	end,
	init_options = {
		typescript = {},
	},
}
