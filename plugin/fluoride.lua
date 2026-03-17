
vim.pack.add({
  "https://github.com/Sang-it/fluoride"
})

require("fluoride").setup({
  window = {
    title = "Fluoride",        -- string or false to disable
    width = 0.3,              -- proportion of terminal width (0-1)
    height = 0.85,            -- proportion of terminal height (0-1)
    row = 2,                  -- fixed rows from top edge
    col = 2,                  -- fixed cols from right edge
    border = "rounded",        -- border style (see below)
    winblend = 15,            -- transparency (0-100)
    footer = true,            -- show/hide help footer
    center_breakpoint = 80,   -- switch to centered layout below this width
  },
  keymaps = {
    close = "q",              -- close the window
    close_alt = "<C-c>",      -- alternative close (set false to disable)
    jump = "<CR>",            -- jump to code point
    peek = "gd",              -- peek at code point (center + flash)
    hover = "K",              -- LSP hover on code point
  },
})
