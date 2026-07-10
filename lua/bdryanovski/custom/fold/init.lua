-- Custom fold module
-- Based on the VimScript example provided

local M = {}
local ns_id = vim.api.nvim_create_namespace('CustomFold')

-- Default configuration
M.config = {
  -- Fold level: levels above this are closed on file open
  level = 2,
  -- Highlight group for line count
  hl_group = 'FoldedLineCount',
  -- Format for line count text
  format = ' %d lines ',
  -- Icon shown before line count
  icon = '',
}

-- Get indent level for a line
function M.indent_level(lnum)
  return math.floor(vim.fn.indent(lnum) / vim.bo.shiftwidth)
end

-- Get next non-blank line
function M.next_nonblank_line(lnum)
  local numlines = vim.fn.line('$')
  local current = lnum + 1

  while current <= numlines do
    if vim.fn.getline(current):match('%S') then
      return current
    end
    current = current + 1
  end

  return -2
end

-- Fold expression based on indentation
function M.foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)

  -- Blank line returns -1
  if line:match('^%s*$') then
    return '-1'
  end

  local this_indent = M.indent_level(lnum)
  local next_indent = M.indent_level(M.next_nonblank_line(lnum))

  if next_indent == this_indent then
    return this_indent
  elseif next_indent < this_indent then
    return this_indent
  elseif next_indent > this_indent then
    return '>' .. next_indent
  end

  return '0'
end

-- Custom fold text with right-aligned line count
function M.foldtext()
  local foldstart = vim.v.foldstart
  local foldend = vim.v.foldend

  -- Get first non-blank line
  local fs = foldstart
  while vim.fn.getline(fs):match('^%s*$') do
    fs = vim.fn.nextnonblank(fs + 1)
    if fs > foldend then
      fs = foldstart
      break
    end
  end

  local line = vim.fn.getline(fs)
  line = line:gsub('\t', string.rep(' ', vim.bo.tabstop))

  -- Calculate available width
  local width = vim.api.nvim_win_get_width(0)
  if vim.wo.number or vim.wo.relativenumber then
    width = width - vim.wo.numberwidth
  end
  if vim.wo.signcolumn ~= 'no' then
    width = width - 2
  end
  local fdc = vim.wo.foldcolumn
  if type(fdc) == 'string' then
    fdc = fdc:match('%d+') or 1
  end
  width = width - tonumber(fdc)

  -- Build right side info
  local fold_size = foldend - foldstart + 1
  local info = ' ' .. fold_size .. ' lines '

  -- Calculate padding
  local line_width = vim.fn.strdisplaywidth(line)
  local info_width = vim.fn.strdisplaywidth(info)
  local padding = width - line_width - info_width

  if padding < 1 then
    padding = 1
  end

  return line .. string.rep(' ', padding) .. info
end

-- Update virtual text for fold line counts (right-aligned)
function M.update_fold_extmarks()
  local buf = vim.api.nvim_get_current_buf()
  local cfg = M.config

  -- Clear existing
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

  local line_count = vim.api.nvim_buf_line_count(buf)
  local lnum = 1

  while lnum <= line_count do
    local fold_start = vim.fn.foldclosed(lnum)
    if fold_start == lnum then
      local fold_end = vim.fn.foldclosedend(lnum)
      local fold_size = fold_end - fold_start + 1
      local text = string.format(cfg.format, fold_size)

      vim.api.nvim_buf_set_extmark(buf, ns_id, lnum - 1, 0, {
        virt_text = {
          { cfg.icon .. ' ', cfg.hl_group },
          { text, cfg.hl_group },
        },
        virt_text_pos = 'right_align',
      })

      lnum = fold_end + 1
    else
      lnum = lnum + 1
    end
  end
end

-- Setup function
function M.setup(opts)
  -- Merge user config
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})

  local cfg = M.config

  -- Set fold level
  vim.opt.foldlevelstart = cfg.level
  vim.opt.fillchars:append({ fold = ' ' })

  -- Create default highlight group for fold line count
  vim.api.nvim_set_hl(0, cfg.hl_group, { link = 'Folded' })

  local group = vim.api.nvim_create_augroup('CustomFold', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = '*',
    callback = function()
      vim.wo.foldenable = true
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.require("bdryanovski.custom.fold").foldexpr()'
      -- Empty foldtext = syntax highlighting preserved (Neovim 0.10+)
      vim.wo.foldtext = ''

      -- Update extmarks after fold settings applied
      vim.defer_fn(M.update_fold_extmarks, 100)
    end,
  })

  -- Update extmarks when folds change
  vim.api.nvim_create_autocmd({ 'WinScrolled', 'CursorMoved' }, {
    group = group,
    pattern = '*',
    callback = function()
      vim.defer_fn(M.update_fold_extmarks, 50)
    end,
  })
end

return M
