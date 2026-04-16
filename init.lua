-- Entry point for the configuration.
-- Sets up fast Lua loading, global project paths and pulls in the core modules.
if vim.loader then
  -- Use the built-in Lua bytecode loader for faster startup.
  vim.loader.enable()
end

require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})

-- If the terminal reports termguicolors support, make sure it is actually enabled.
if vim.opt.termguicolors then
  vim.opt.termguicolors = true
end

-- Global project directory roots used by custom UI (e.g. navbar) to label paths.
vim.g.projects_dir = vim.env.HOME .. '/Projects'
vim.g.github_projects_dir = vim.env.HOME .. '/Github'
vim.g.work_projects_dir = vim.env.HOME .. '/Manual'

-- Core layers: options, autocmds, keymaps, LSP and optional Neovide tweaks.
require('bdryanovski.base')
require('bdryanovski.base.autocmd')
require('bdryanovski.base.mapping')
require('bdryanovski.core.lsp')
require('bdryanovski.neovide')

-- Whenever vim.pack installs or updates plugins, rebuild blink.cmp if needed.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/blink.cmp'
      vim.notify('Building blink.cmp', vim.log.levels.INFO)
      local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = path }):wait()
      if obj.code == 0 then
        vim.notify('Building blink.cmp done', vim.log.levels.INFO)
      else
        vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
      end
    end
  end,
})
--
-- vim.opt.guicursor = {
-- 	"n-v:block-Cursor/lCursor",
-- 	"i-c-ci-ve:block-TermCursor",
-- }
-- set guicursor=n-v-c-i:block
--
-- set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
-- 		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
-- 		  \,sm:block-blinkwait175-blinkoff150-blinkon175

-- Source - https://stackoverflow.com/a/75967251
-- Posted by trash bin, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-03-10, License - CC BY-SA 4.0
-- Configure cursor shapes per mode:
--   - Normal/Visual/Command: block cursor with custom blink timings.
--   - Insert/Command-insert/Visual-ex: vertical bar.
--   - Replace/Operator-pending: horizontal bar.
vim.opt.guicursor =
  'n-v-c-sm:block-nCursor-blinkwait300-blinkon200-blinkoff150,i-ci-ve:ver100,r-cr-o:hor20'

-- vim.opt.gcr = {
-- 	"i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor",
-- 	"n-v:block-Curosr/lCursor",
-- 	"o:hor50-Curosr/lCursor",
-- 	"r-cr:hor20-Curosr/lCursor",
-- }
