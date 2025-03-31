if vim.loader then
	vim.loader.enable()
end

if vim.opt.termguicolors then
	vim.opt.termguicolors = true
end

require("bdryanovski.base")
require("bdryanovski.base.autocmd")
require("bdryanovski.base.mapping")
require("bdryanovski.lazy")
require("bdryanovski.neovide")
