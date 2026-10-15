-- monoz todo-comments.nvim groups
-- todo-comments derives its own highlights from its `colors` config. These
-- defaults keep the fallback groups on-theme if colors are left unset.
local M = {}

M.url = 'https://github.com/folke/todo-comments.nvim'

---@type monoz.HighlightsFn
function M.get(c, opts)
    return {
        TodoBgTODO = { fg = c.black, bg = c.todo, bold = true },
        TodoFgTODO = { fg = c.todo },
        TodoSignTODO = { fg = c.todo },
        TodoBgFIX = { fg = c.black, bg = c.error, bold = true },
        TodoFgFIX = { fg = c.error },
        TodoSignFIX = { fg = c.error },
        TodoBgHACK = { fg = c.black, bg = c.warning, bold = true },
        TodoFgHACK = { fg = c.warning },
        TodoSignHACK = { fg = c.warning },
        TodoBgWARN = { fg = c.black, bg = c.warning, bold = true },
        TodoFgWARN = { fg = c.warning },
        TodoSignWARN = { fg = c.warning },
        TodoBgPERF = { fg = c.black, bg = c.hint, bold = true },
        TodoFgPERF = { fg = c.hint },
        TodoSignPERF = { fg = c.hint },
        TodoBgNOTE = { fg = c.black, bg = c.info, bold = true },
        TodoFgNOTE = { fg = c.info },
        TodoSignNOTE = { fg = c.info },
        TodoBgTEST = { fg = c.black, bg = c.ok, bold = true },
        TodoFgTEST = { fg = c.ok },
        TodoSignTEST = { fg = c.ok },
    }
end

return M
