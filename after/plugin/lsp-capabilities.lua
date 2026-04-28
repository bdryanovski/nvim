local capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)

vim.lsp.config('*', {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  root_markets = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' },
})
