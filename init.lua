if vim.loader then
	vim.loader.enable()
end

if vim.opt.termguicolors then
	vim.opt.termguicolors = true
end

-- Global variables.
vim.g.projects_dir = vim.env.HOME .. "/Projects"

vim.g.github_projects_dir = vim.env.HOME .. "/Github"
vim.g.work_projects_dir = vim.env.HOME .. "/Manual"

require("navbar")

require("bdryanovski.base")
require("bdryanovski.base.autocmd")
require("bdryanovski.base.mapping")
require("bdryanovski.core.lsp")
require("bdryanovski.lazy")
require("bdryanovski.neovide")
