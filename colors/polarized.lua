require("xeno").setup({
  background = "#0a141c",
  accent = "#3ddc97",
  properties = {
    contrast = 0.1,
    variation = 0.1,
    chroma = 0.1,
    lightness = -0.1,
  },
  transparent = false,
  foreground = "#c9dde2",
  _custom_colors = {
    teal = "#2ec4b6",
    glow_pink = "#e39fc2",
    indigo = "#7c93e0",
    cyan = "#4fd9e8",
    aurora = "#3ddc97",
    violet = "#9b7fd4",
    ice = "#8ecae6",
    frost = "#a8e6cf"
  },
  highlights = {
    syntax = {
      Function = {
        fg = "@teal.300"
      },
      String = {
        fg = "@aurora.100"
      },
      ["@lsp.typemod.property.declaration"] = {
        link = "@property"
      },
      ["@property"] = {
        link = "Property"
      },
      ["@lsp.mod.declaration"] = {
        clear = true
      },
      Operator = {
        fg = "@cyan.300"
      },
      ["@keyword"] = {
        link = "Keyword"
      },
      ["@lsp.type.type"] = {
        link = "@type"
      },
      Type = {
        fg = "@cyan.200"
      },
      Variable = {
        fg = "@foreground.300"
      },
      ["@function"] = {
        link = "Function"
      },
      ["@lsp.type.property"] = {
        link = "@property"
      },
      ["@lsp.type.variable"] = {
        link = "@variable"
      },
      ["@variable"] = {
        link = "Variable"
      },
      ["@punctuation.delimiter"] = {
        link = "Punctuation"
      },
      Punctuation = {
        fg = "@foreground.400"
      },
      ["@punctuation.bracket"] = {
        link = "Punctuation"
      },
      ["@punctuation"] = {
        link = "Punctuation"
      },
      Boolean = {
        fg = "@frost.100"
      },
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      Property = {
        fg = "@ice.300"
      },
      Conditional = {
        fg = "@indigo.300"
      },
      ["@constant.builtin"] = {
        fg = "@glow_pink.100",
        bold = true
      },
      Number = {
        fg = "@frost.100"
      },
      ["@constant"] = {
        fg = "@frost.200"
      },
      ["@boolean"] = {
        link = "Boolean"
      },
      ["@number"] = {
        link = "Number"
      },
      ["@string.escape"] = {
        fg = "@ice.100"
      },
      ["@string"] = {
        link = "String"
      },
      ["@function.builtin"] = {
        fg = "@cyan.100"
      },
      ["@keyword.import"] = {
        fg = "@teal.400"
      },
      ["@keyword.operator"] = {
        fg = "@cyan.300"
      },
      Comment = {
        italic = true,
        fg = "@foreground.400"
      },
      ["@keyword.repeat"] = {
        link = "Conditional"
      },
      ["@keyword.conditional"] = {
        link = "Conditional"
      },
      ["@keyword.function"] = {
        link = "Conditional"
      },
      ["@keyword.return"] = {
        link = "Keyword"
      },
      ["@type"] = {
        link = "Type"
      },
      ["@variable.builtin"] = {
        fg = "@indigo.200"
      },
      ["@operator"] = {
        link = "Operator"
      },
      ["@lsp.type.function"] = {
        link = "@function"
      },
      ["@lsp.type.keyword"] = {
        link = "@keyword"
      },
      Keyword = {
        fg = "@violet.300"
      }
    },
    editor = {
      IncSearch = {
        bg = {
          fg = "@frost.300",
          opacity = 0.35,
          __xeno_opaque = true
        },
        fg = "@background.950"
      },
      CursorLine = {
        bg = {
          fg = "@teal.600",
          opacity = 0.06,
          __xeno_opaque = true
        }
      },
      Search = {
        bg = {
          fg = "@cyan.400",
          opacity = 0.25,
          __xeno_opaque = true
        },
        fg = "@foreground.50"
      },
      CursorLineNr = {
        fg = "@frost.100",
        bold = true
      },
      Visual = {
        bg = {
          fg = "@aurora.500",
          opacity = 0.18,
          __xeno_opaque = true
        }
      },
      MatchParen = {
        fg = "@frost.100",
        bold = true
      }
    }
  },
  integrations = {
    ghostty = {
      enabled = false,
      update_config = false
    }
  },
})
vim.g.colors_name = "polarized"
