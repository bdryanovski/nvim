vim.pack.add({
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/copilotlsp-nvim/copilot-lsp",
})

require('copilot').setup({
    -- The panel is useless.
    panel = { enabled = false },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = false, -- handled manually below with proper fallback
        dismiss = "<Esc>",
      },
    },
    -- Disable copilot in certain filetypes
    filetypes = {
      markdown = true,
      yaml = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
})

-- Accept Copilot suggestion with Tab, or fall back to inserting a real Tab character
vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false
    )
  end
end, { desc = "Accept Copilot or insert Tab" })
