-- monoz snacks.nvim groups
local M = {}

M.url = 'https://github.com/folke/snacks.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    local ret = {
        -- dashboard
        SnacksDashboardHeader = { fg = c.glow },
        SnacksDashboardFooter = { fg = c.gray5 },
        SnacksDashboardTitle = { fg = c.title },
        SnacksDashboardIcon = { fg = c.icon },
        SnacksDashboardKey = { fg = c.glow },
        SnacksDashboardDesc = { fg = c.fg },
        SnacksDashboardSpecial = { fg = c.lack },
        SnacksDashboardDir = { fg = c.gray5 },
        SnacksDashboardFile = { fg = c.fs.file },

        -- indent
        SnacksIndent = { fg = c.gray3 },
        SnacksIndentScope = { fg = c.gray5 },

        -- input
        SnacksInputBorder = { fg = c.border, bg = c.bg_popup },
        SnacksInputTitle = { fg = c.title, bg = c.bg_popup },
        SnacksInputIcon = { fg = c.glow },

        -- notifier
        SnacksNotifierInfo = { fg = c.info },
        SnacksNotifierWarn = { fg = c.warning },
        SnacksNotifierError = { fg = c.error },
        SnacksNotifierDebug = { fg = c.gray6 },
        SnacksNotifierTrace = { fg = c.lack },
        SnacksNotifierIconInfo = { fg = c.info },
        SnacksNotifierIconWarn = { fg = c.warning },
        SnacksNotifierIconError = { fg = c.error },
        SnacksNotifierTitleInfo = { fg = c.info, bold = true },
        SnacksNotifierTitleWarn = { fg = c.warning, bold = true },
        SnacksNotifierTitleError = { fg = c.error, bold = true },
        SnacksNotifierBorderInfo = { fg = c.border, bg = c.bg_popup },
        SnacksNotifierBorderWarn = { fg = c.border, bg = c.bg_popup },
        SnacksNotifierBorderError = { fg = c.border, bg = c.bg_popup },

        -- picker
        SnacksPicker = { fg = c.fg, bg = c.bg_popup },
        SnacksPickerBorder = { fg = c.border, bg = c.bg_popup },
        SnacksPickerTitle = { fg = c.title, bold = true },
        SnacksPickerPrompt = { fg = c.glow, bold = true },
        SnacksPickerInputBorder = { fg = c.border, bg = c.bg_popup },
        SnacksPickerMatch = { fg = c.glow, bold = true },
        SnacksPickerDir = { fg = c.gray5 },
        SnacksPickerFile = { fg = c.fs.file },
        SnacksPickerSelected = { fg = c.glow },
        SnacksPickerPathHidden = { fg = c.gray5 },
        SnacksPickerPathIgnored = { fg = c.gray4 },
        SnacksPickerListCursorLine = { bg = c.selection },

        -- scratch / misc
        SnacksScratchTitle = { fg = c.title, bold = true },
        SnacksScratchDesc = { fg = c.gray6 },
        SnacksScratchKey = { fg = c.glow },
    }
    return ret
end

return M
