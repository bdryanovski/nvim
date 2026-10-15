-- monoz
-- A personal colorscheme forked from monoglow.nvim (https://github.com/wnkz/monoglow.nvim).
-- monoglow includes code derived from tokyonight.nvim, licensed under the
-- Apache License, Version 2.0.

local config = require('bdryanovski.monoz.config')

local M = {}

---@param opts? monoz.Config
function M.load(opts)
    opts = config.extend(opts)
    return require('bdryanovski.monoz.theme').setup(opts)
end

M.setup = config.setup

return M
