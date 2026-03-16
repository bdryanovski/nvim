--- pack.lua - Thin wrapper around vim.pack with lazy loading
---
--- Extends vim.pack.add() with `event` and `ft` fields for deferred loading.
--- Remote plugins are installed immediately via vim.pack but loaded on trigger.
--- Local plugins (via `dir`) are loaded by prepending to runtimepath.
---
--- Usage:
---   local pack = require("bdryanovski.pack")
---
---   -- Immediate load (plain vim.pack passthrough)
---   pack.add({
---     "https://github.com/nvim-lua/plenary.nvim",
---     { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") },
---   })
---
---   -- Lazy load on event
---   pack.add({
---     src = "https://github.com/nvim-mini/mini.completion",
---     event = "InsertEnter",
---     config = function()
---       require("mini.completion").setup()
---     end,
---   })
---
---   -- Lazy load on filetype
---   pack.add({
---     src = "https://github.com/ray-x/go.nvim",
---     ft = { "go", "gomod" },
---     config = function()
---       require("go").setup()
---     end,
---   })
---
---   -- Local plugin with lazy loading
---   pack.add({
---     dir = vim.fn.stdpath("config") .. "/lua/bdryanovski/custom/indent",
---     name = "indent",
---     event = "BufReadPost",
---     config = function()
---       require("bdryanovski.custom.indent").setup({})
---     end,
---   })

local M = {}
local H = {}

H.loaded = {}
H.lazy_registry = {}
H.group = vim.api.nvim_create_augroup("Pack", { clear = true })

--- Add one or more plugin specs.
---
--- Each item can be:
---   - A string URL (forwarded to vim.pack.add, loaded immediately)
---   - A table spec with optional lazy-loading fields:
---       src     : string           - Git URL (remote plugins)
---       dir     : string           - Filesystem path (local plugins)
---       name    : string           - Override inferred plugin name
---       version : string|Range     - Version constraint (forwarded to vim.pack)
---       event   : string|string[]  - Autocommand event(s) that trigger loading
---       ft      : string|string[]  - Filetype(s) that trigger loading
---       config  : function         - Called after the plugin is loaded
---       enabled : boolean          - false to skip entirely (default true)
---
--- Specs without `event`/`ft` are loaded immediately.
--- Specs with `event`/`ft` are installed (remote) but loaded only on trigger.
---@param specs string|table
function M.add(specs)
  if type(specs) ~= "table" then
    return
  end

  local items = specs
  if specs.src or specs.dir then
    items = { specs }
  end

  local eager_remote = {}
  local eager_local = {}
  local lazy_specs = {}

  for _, spec in ipairs(items) do
    if type(spec) == "string" then
      table.insert(eager_remote, spec)
    elseif spec.enabled == false then
      -- skip disabled
    elseif spec.event or spec.ft then
      table.insert(lazy_specs, spec)
    elseif spec.dir then
      table.insert(eager_local, spec)
    else
      table.insert(eager_remote, H.to_pack_spec(spec))
    end
  end

  if #eager_remote > 0 then
    vim.pack.add(eager_remote)
  end

  for _, spec in ipairs(eager_local) do
    H.load_local(spec)
    if spec.config then
      spec.config()
    end
  end

  for _, spec in ipairs(lazy_specs) do
    H.register_lazy(spec)
  end
end

-- ---------------------------------------------------------------------------
-- Internals
-- ---------------------------------------------------------------------------

---@param spec table
---@return string
function H.resolve_name(spec)
  if spec.name then
    return spec.name
  end
  if spec.dir then
    return vim.fn.fnamemodify(spec.dir, ":t")
  end
  if spec.src then
    return spec.src:match("([^/]+)$") or spec.src
  end
  error("[pack] cannot infer plugin name from spec")
end

---@param spec string|table
---@return string|table
function H.to_pack_spec(spec)
  if type(spec) == "string" then
    return spec
  end
  local out = { src = spec.src }
  if spec.name then
    out.name = spec.name
  end
  if spec.version then
    out.version = spec.version
  end
  return out
end

--- Register a lazy plugin: install (remote) but defer loading.
function H.register_lazy(spec)
  local name = H.resolve_name(spec)
  H.lazy_registry[name] = spec

  if spec.src then
    vim.pack.add({ H.to_pack_spec(spec) }, { load = function() end })
  end

  H.create_triggers(name, spec)
end

--- Wire up autocommands for the lazy triggers.
function H.create_triggers(name, spec)
  local function on_trigger(ev)
    H.load_lazy(name, ev)
  end

  if spec.event then
    local events = type(spec.event) == "string" and { spec.event } or spec.event

    for _, raw in ipairs(events) do
      if raw == "VeryLazy" then
        vim.api.nvim_create_autocmd("UIEnter", {
          group = H.group,
          once = true,
          callback = function()
            vim.schedule(function()
              on_trigger({ event = "UIEnter" })
            end)
          end,
        })
      else
        local ev_name, pattern = raw, "*"
        local space = raw:find(" ")
        if space then
          ev_name = raw:sub(1, space - 1)
          pattern = raw:sub(space + 1)
        end

        vim.api.nvim_create_autocmd(ev_name, {
          group = H.group,
          pattern = pattern,
          once = true,
          callback = function(ev)
            on_trigger(ev)
          end,
        })
      end
    end
  end

  if spec.ft then
    local filetypes = type(spec.ft) == "string" and { spec.ft } or spec.ft

    vim.api.nvim_create_autocmd("FileType", {
      group = H.group,
      pattern = filetypes,
      once = true,
      callback = function(ev)
        on_trigger(ev)
      end,
    })
  end
end

--- Actually load a lazy plugin and run its config.
function H.load_lazy(name, trigger_ev)
  if H.loaded[name] then
    return
  end
  H.loaded[name] = true

  local spec = H.lazy_registry[name]
  if not spec then
    return
  end

  if spec.dir then
    H.load_local(spec)
  else
    vim.cmd.packadd(name)
  end

  if spec.config then
    -- Log message 
    spec.config()
  end

  H.retrigger(trigger_ev)
end

--- Add a local plugin directory to runtimepath and source its scripts.
function H.load_local(spec)
  local dir = spec.dir
  if not dir then
    return
  end

  if not vim.list_contains(vim.opt.rtp:get(), dir) then
    vim.opt.rtp:prepend(dir)
  end

  for _, subdir in ipairs({ "plugin", "ftdetect" }) do
    local path = dir .. "/" .. subdir
    if vim.fn.isdirectory(path) == 1 then
      for _, ext in ipairs({ "*.lua", "*.vim" }) do
        for _, file in ipairs(vim.fn.glob(path .. "/" .. ext, false, true)) do
          vim.cmd.source(file)
        end
      end
    end
  end
end

--- Re-fire the triggering event so the freshly loaded plugin sees it.
function H.retrigger(ev)
  if not ev or not ev.event then
    return
  end

  local event = ev.event

  if event == "User" or event == "UIEnter" then
    return
  end

  if event == "FileType" then
    if ev.buf and vim.api.nvim_buf_is_valid(ev.buf) then
      local ft = vim.bo[ev.buf].filetype
      if ft and ft ~= "" then
        vim.api.nvim_buf_call(ev.buf, function()
          vim.cmd("doautocmd FileType " .. ft)
        end)
      end
    end
    return
  end

  pcall(vim.api.nvim_exec_autocmds, event, {
    buffer = ev.buf,
    modeline = false,
  })
end

return M
