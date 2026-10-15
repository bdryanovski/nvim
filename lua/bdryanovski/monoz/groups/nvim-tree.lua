-- monoz nvim-tree groups
local M = {}

M.url = 'https://github.com/nvim-tree/nvim-tree.lua'

---@type monoz.HighlightsFn
function M.get(c, opts)
    return {
        NvimTreeNormal = { fg = c.fg_sidebar, bg = opts.transparent and c.none or c.bg },
        NvimTreeNormalNC = 'NvimTreeNormal',
        NvimTreeWinSeparator = { fg = c.border, bg = opts.transparent and c.none or c.bg },
        NvimTreeEndOfBuffer = { fg = opts.eob and c.gray2 or c.bg },
        NvimTreeRootFolder = { fg = c.title, bold = true },
        NvimTreeFolderName = { fg = c.fs.dir },
        NvimTreeFolderIcon = { fg = c.fs.dir },
        NvimTreeOpenedFolderName = { fg = c.fs.dir, bold = true },
        NvimTreeEmptyFolderName = { fg = c.gray5 },
        NvimTreeFolderArrowClosed = { fg = c.gray6 },
        NvimTreeFolderArrowOpen = { fg = c.gray6 },
        NvimTreeFileName = { fg = c.fs.file },
        NvimTreeSpecialFile = { fg = c.luster, bold = true },
        NvimTreeExecFile = { fg = c.fs.exec },
        NvimTreeSymlink = { fg = c.fs.link },
        NvimTreeImageFile = { fg = c.fg },
        NvimTreeIndentMarker = { fg = c.gray4 },
        NvimTreeWindowPicker = { fg = c.black, bg = c.glow, bold = true },
        NvimTreeGitDirty = { fg = c.git.change },
        NvimTreeGitStaged = { fg = c.git.add },
        NvimTreeGitMerge = { fg = c.lack },
        NvimTreeGitRenamed = { fg = c.git.change },
        NvimTreeGitNew = { fg = c.git.add },
        NvimTreeGitDeleted = { fg = c.git.delete },
        NvimTreeGitIgnored = { fg = c.gray5 },
        NvimTreeCutHL = { fg = c.git.delete },
        NvimTreeCopiedHL = { fg = c.git.add },
    }
end

return M
