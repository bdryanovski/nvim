-- monoz noice.nvim groups
local M = {}

M.url = 'https://github.com/folke/noice.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    return {
        NoiceCmdline = { fg = c.fg, bg = c.none },
        NoiceCmdlinePopup = { fg = c.fg, bg = c.bg_popup },
        NoiceCmdlinePopupBorder = { fg = c.border, bg = c.bg_popup },
        NoiceCmdlinePopupTitle = { fg = c.title, bold = true },
        NoiceCmdlineIcon = { fg = c.glow },
        NoiceCmdlineIconSearch = { fg = c.git.change },
        NoiceConfirm = { fg = c.fg, bg = c.bg_popup },
        NoiceConfirmBorder = { fg = c.border, bg = c.bg_popup },
        NoicePopup = { fg = c.fg, bg = c.bg_popup },
        NoicePopupBorder = { fg = c.border, bg = c.bg_popup },
        NoicePopupmenu = { fg = c.fg, bg = c.bg_menu },
        NoicePopupmenuBorder = { fg = c.border, bg = c.bg_menu },
        NoicePopupmenuSelected = { fg = c.black, bg = c.glow, bold = true },
        NoicePopupmenuMatch = { fg = c.glow, bold = true },
        NoiceMini = { fg = c.fg_sidebar, bg = c.bg_statusline },
        NoiceVirtualText = { fg = c.gray6 },
        NoiceFormatProgressDone = { fg = c.black, bg = c.glow },
        NoiceFormatProgressTodo = { fg = c.fg, bg = c.gray3 },
        NoiceLspProgressClient = { fg = c.title, bold = true },
        NoiceLspProgressSpinner = { fg = c.glow },
        NoiceLspProgressTitle = { fg = c.fg },
        NoiceScrollbar = { bg = c.bg_popup },
        NoiceScrollbarThumb = { bg = c.gray4 },
    }
end

return M
