-- monoz barbecue groups
-- barbecue renders the winbar breadcrumb and reads nvim-navic icon groups.
local M = {}

M.url = 'https://github.com/utilyre/barbecue.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    local ret = {
        BarbecueNormal = { fg = c.fg_sidebar, bg = c.none },
        BarbecueSeparator = { fg = c.gray5 },
        BarbecueDirname = { fg = c.gray5 },
        BarbecueBasename = { fg = c.fg },
        BarbecueModified = { fg = c.git.change },
        BarbecueContext = { fg = c.gray7 },
        BarbecueEllipsis = { fg = c.gray5 },
        -- navic text
        NavicText = { fg = c.fg },
        NavicSeparator = { fg = c.gray5 },
    }
    -- Map navic icon groups to the LSP kind highlights (produced by kinds.lua).
    require('bdryanovski.monoz.groups.kinds').kinds(ret, 'NavicIcons%s')
    return ret
end

return M
