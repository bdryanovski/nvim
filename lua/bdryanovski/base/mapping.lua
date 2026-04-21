-- Core key mappings
--
-- Leader is used as a prefix for many mappings (<leader> = ",").
vim.g.mapleader = ','

local keymap = vim.keymap

-- Navigation arround panes
--
keymap.set('n', '<C-k>', ':wincmd k<CR>')
keymap.set('n', '<C-j>', ':wincmd j<CR>')
keymap.set('n', '<C-h>', ':wincmd h<CR>')
keymap.set('n', '<C-l>', ':wincmd l<CR>')

-- General editing
keymap.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights', silent = true })
keymap.set('n', '+', '<C-a>', { desc = 'Increment number under the cursor', silent = true })
keymap.set('n', '-', '<C-x>', { desc = 'Decrement number under the cursor', silent = true })
keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select entire buffer', silent = true })
keymap.set('n', 'H', '^', { desc = 'Go to first non blank character', silent = true })

-- Move selected lines up/down in visual mode.
keymap.set('x', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move selection up', silent = true })
keymap.set('x', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move selection down', silent = true })

-- Tabs and tab navigation
keymap.set('n', '<leader>te', ':tabedit', { desc = 'Create new tab', silent = true })
keymap.set('n', '<tab>', ':tabnext<CR>', { desc = 'Switch to next tab', silent = true })
keymap.set('n', '<s-tab>', ':tabprev<CR>', { desc = 'Go to previous tab', silent = true })
keymap.set('n', '<C-w>', ':tabclose<Return>', { desc = 'Close current tab', silent = true })
keymap.set(
  'n',
  '<C-to>',
  ':tabonly<CR>',
  { desc = 'Close all other tabs', noremap = true, silent = true }
)

-- Window management (splits and navigation)
keymap.set('n', '<Space>', '<C-w>w', { desc = 'Cycle to next window', remap = true })
keymap.set('', 's<left>', '<C-w>h', { desc = 'Focus left window', remap = true })
keymap.set('', 's<right>', '<C-w>l', { desc = 'Focus right window', remap = true })
keymap.set('', 's<up>', '<C-w>k', { desc = 'Focus upper window', remap = true })
keymap.set('', 's<down>', '<C-w>j', { desc = 'Focus lower window', remap = true })
keymap.set('n', 'ss', ':split<Return><C-w>w', { desc = 'Horizontal split', silent = true })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { desc = 'Vertical split', silent = true })
keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Save from various modes with <C-s>.
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Keep visual selection when indenting.
keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Command aliases (quality of life)
-- See :help nvim_create_user_command()
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})

keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Diagnostics
keymap.set('n', '<C-j>', function()
  vim.diagnostic.goto_next({ popup_opts = { border = 'rounded' } })
end, { desc = 'Go to next diagnostic', silent = true })

-- Hardmode: disable arrow keys in normal/visual mode to encourage hjkl.
keymap.set({ 'n', 'v' }, '<Up>', '<Nop>', { noremap = true })
keymap.set({ 'n', 'v' }, '<Down>', '<Nop>', { noremap = true })
keymap.set({ 'n', 'v' }, '<Left>', '<Nop>', { noremap = true })
keymap.set({ 'n', 'v' }, '<Right>', '<Nop>', { noremap = true })

-- neovim undotree
keymap.set('n', '<leader>u', function()
  vim.cmd.packadd('nvim.undotree')
  require('undotree').open()
end, { desc = 'Toggle undo tree' })
