-- monoz incline.nvim groups
local M = {}

M.url = 'https://github.com/b0o/incline.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    return {
        InclineNormal = { fg = c.fg_sidebar, bg = c.bg_statusline },
        InclineNormalNC = { fg = c.fg_gutter, bg = c.bg_statusline },
    }
end

return M
