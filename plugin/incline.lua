vim.pack.add({
  "https://github.com/b0o/incline.nvim",
})

local helpers = require("incline.helpers")

require("incline").setup({
  window = {
    padding = 0,
    margin = { horizontal = 0 },
  },
  hide = { cursorline = true, focused_win = true },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end
    local ft_icon, ft_hl, _ = MiniIcons.get("file", filename)
    local ft_color = ft_hl and vim.api.nvim_get_hl(0, { name = ft_hl, link = false }).fg
    if ft_color then
      ft_color = string.format("#%06x", ft_color)
    end

    local res = {
      ft_icon and ft_color
          and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) }
        or "",
      { " " .. filename .. " ", gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
    }

    table.insert(res, " ")

    return res
  end,
})
