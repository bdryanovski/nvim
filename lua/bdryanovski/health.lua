-- Documentation for this module can be found at: https://neovim.io/doc/user/health.html
--
local Module = {}

local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function Module.check()
	start("bdryanovski.nvim Health Check")

	if vim.fn.has("nvim-0.11.0") == 1 then
		ok("Using Neovim >= 0.11.0")
		if vim.fn.has("nvim-0.11.1") == 0 then
			warn("Use Neovim >= 0.10.0 for the best experience")
		end
	else
		error("Neovim >= 0.11.0 is required")
	end

	for _, cmd in ipairs({ "git", "rg", { "fd", "fdfind" }, "lazygit", "fzf", "curl" }) do
		local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
		local commands = type(cmd) == "string" and { cmd } or cmd
		---@cast commands string[]
		local found = false

		for _, c in ipairs(commands) do
			if vim.fn.executable(c) == 1 then
				name = c
				found = true
			end
		end

		if found then
			ok(("`%s` is installed"):format(name))
		else
			warn(("`%s` is not installed"):format(name))
		end
	end
end

return Module
