vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/antosha417/nvim-lsp-file-operations',
  'https://github.com/Kaiser-Yang/blink-cmp-git',
})

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  signature = {
    enabled = true,
    trigger = {
      enabled = true,
    },
    window = { show_documentation = true, border = 'rounded' },
  },

  completion = {
    accept = { auto_brackets = { enabled = true } },
    list = {
      max_items = 10,
      selection = { preselect = true, auto_insert = true },
    },

    menu = {
      border = 'rounded',

      draw = {
        treesitter = { 'lsp' },
        columns = {
          { 'kind_icon', 'kind', gap = 1 },
          { 'label', 'label_description', gap = 1 },
          { 'source_name' },
        },
        components = {
          kind_icon = {
            text = function(ctx)
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local icon, _, _ = MiniIcons.get('file', ctx.label)
                if icon then
                  return icon .. ctx.icon_gap
                end
              else
                local icon, _, _ = MiniIcons.get('lsp', ctx.kind)
                if icon then
                  return icon .. ctx.icon_gap
                end
              end
              return ctx.kind_icon .. ctx.icon_gap
            end,

            highlight = function(ctx)
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local _, hl, _ = MiniIcons.get('file', ctx.label)
                if hl then
                  return hl
                end
              end
              return ctx.kind_hl
            end,
          },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      treesitter_highlighting = true,
      window = { border = 'rounded' },
    },

    ghost_text = { enabled = false },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      sql = { 'snippets', 'buffer' },
    },
    providers = {
      git = {
        module = 'blink-cmp-git',
        name = 'Git',
        opts = {},
      },
      lsp = {
        min_keyword_length = 2,
        score_offset = 0,
      },
      path = {
        min_keyword_length = 0,
      },
      snippets = {
        min_keyword_length = 2,
      },
      buffer = {
        min_keyword_length = 5,
        max_items = 5,
      },
    },
  },

  fuzzy = { implementation = 'prefer_rust' },

  snippets = {
    preset = 'default',
  },
})
