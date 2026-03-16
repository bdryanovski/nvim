if vim.loader then
	vim.loader.enable()
end

if vim.opt.termguicolors then
	vim.opt.termguicolors = true
end

-- Global variables.
vim.g.projects_dir = vim.env.HOME .. "/Projects"
vim.g.github_projects_dir = vim.env.HOME .. "/Github"
vim.g.work_projects_dir = vim.env.HOME .. "/Manual"

require("bdryanovski.base")
require("bdryanovski.base.autocmd")
require("bdryanovski.base.mapping")
require("bdryanovski.core.lsp")
require("bdryanovski.neovide")


vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "blink.cmp" and (kind == "install" or kind == "update") then
      local path = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
      vim.notify("Building blink.cmp", vim.log.levels.INFO)
      local obj = vim.system({ "cargo", "build", "--release" }, { cwd = path }):wait()
      if obj.code == 0 then
        vim.notify("Building blink.cmp done", vim.log.levels.INFO)
      else
        vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
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
vim.opt.guicursor = "n-v-c-sm:block-nCursor-blinkwait300-blinkon200-blinkoff150,i-ci-ve:ver100,r-cr-o:hor20"
