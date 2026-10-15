-- monoz mini.nvim groups
-- This config installs mini.icons and mini.pairs. mini.icons reads the color
-- groups below. The extra mini.* groups are harmless when the module is absent.
local M = {}

M.url = 'https://github.com/echasnovski/mini.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    local a = c.accents
    return {
        -- mini.icons
        MiniIconsAzure = { fg = a.cyan },
        MiniIconsBlue = { fg = a.blue },
        MiniIconsCyan = { fg = a.teal },
        MiniIconsGreen = { fg = a.green },
        MiniIconsGrey = { fg = c.gray7 },
        MiniIconsOrange = { fg = a.orange },
        MiniIconsPurple = { fg = a.purple },
        MiniIconsRed = { fg = a.red },
        MiniIconsYellow = { fg = a.yellow },

        -- mini.statusline
        MiniStatuslineModeNormal = { fg = c.mode.normal.fg, bg = c.mode.normal.bg, bold = true },
        MiniStatuslineModeInsert = { fg = c.mode.insert.fg, bg = c.mode.insert.bg, bold = true },
        MiniStatuslineModeVisual = { fg = c.mode.visual.fg, bg = c.mode.visual.bg, bold = true },
        MiniStatuslineModeReplace = { fg = c.mode.replace.fg, bg = c.mode.replace.bg, bold = true },
        MiniStatuslineModeCommand = { fg = c.mode.command.fg, bg = c.mode.command.bg, bold = true },
        MiniStatuslineDevinfo = { fg = c.gray7, bg = c.bg_statusline },
        MiniStatuslineFilename = { fg = c.fg_sidebar, bg = c.bg_statusline },
        MiniStatuslineInactive = { fg = c.fg_gutter, bg = c.bg_statusline },

        -- mini.tabline
        MiniTablineCurrent = { fg = c.fg, bg = c.gray3, bold = true },
        MiniTablineVisible = { fg = c.gray7, bg = c.bg_statusline },
        MiniTablineHidden = { fg = c.gray5, bg = c.bg_statusline },
        MiniTablineModifiedCurrent = { fg = c.git.change, bg = c.gray3, bold = true },
        MiniTablineModifiedVisible = { fg = c.git.change, bg = c.bg_statusline },
        MiniTablineModifiedHidden = { fg = c.gray5, bg = c.bg_statusline },
        MiniTablineFill = { bg = c.bg },

        -- mini.indentscope / mini.cursorword / mini.trailspace
        MiniIndentscopeSymbol = { fg = c.gray5 },
        MiniIndentscopePrefix = { nocombine = true },
        MiniCursorword = { bg = c.lsp_ref },
        MiniCursorwordCurrent = { bg = c.lsp_ref },
        MiniTrailspace = { bg = c.error },

        -- mini.files / mini.pick / mini.notify
        MiniFilesTitle = { fg = c.title },
        MiniFilesTitleFocused = { fg = c.title, bold = true },
        MiniFilesBorder = { fg = c.border, bg = c.bg_popup },
        MiniFilesNormal = { fg = c.fg, bg = c.bg_popup },
        MiniPickPrompt = { fg = c.glow, bold = true },
        MiniPickMatchCurrent = { bg = c.selection },
        MiniPickBorder = { fg = c.border, bg = c.bg_popup },
        MiniNotifyNormal = { fg = c.fg, bg = c.bg_popup },
        MiniNotifyBorder = { fg = c.border, bg = c.bg_popup },
        MiniNotifyTitle = { fg = c.title, bold = true },
    }
end

return M
