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
    indigo = "#7c93e0",
    teal = "#2ec4b6",
    violet = "#9b7fd4",
    aurora = "#3ddc97",
    ice = "#8ecae6",
    frost = "#a8e6cf",
    glow_pink = "#e39fc2",
    cyan = "#4fd9e8"
  },
  highlights = {
    syntax = {
      Boolean = {
        fg = "@frost.100"
      },
      Property = {
        fg = "@ice.300"
      },
      Comment = {
        italic = true,
        fg = "@foreground.400"
      },
      ["@lsp.typemod.property.declaration"] = {
        link = "@property"
      },
      Keyword = {
        fg = "@violet.300"
      },
      ["@lsp.mod.declaration"] = {
        clear = true
      },
      ["@lsp.type.keyword"] = {
        link = "@keyword"
      },
      ["@keyword"] = {
        link = "Keyword"
      },
      ["@lsp.type.type"] = {
        link = "@type"
      },
      ["@type"] = {
        link = "Type"
      },
      ["@lsp.type.function"] = {
        link = "@function"
      },
      ["@function"] = {
        link = "Function"
      },
      ["@lsp.type.property"] = {
        link = "@property"
      },
      Function = {
        fg = "@teal.300"
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
      String = {
        fg = "@aurora.100"
      },
      ["@punctuation"] = {
        link = "Punctuation"
      },
      ["@operator"] = {
        link = "Operator"
      },
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      Operator = {
        fg = "@cyan.300"
      },
      Number = {
        fg = "@frost.100"
      },
      ["@constant.builtin"] = {
        bold = true,
        fg = "@glow_pink.100"
      },
      Variable = {
        fg = "@foreground.300"
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
      ["@constant"] = {
        fg = "@frost.200"
      },
      ["@variable.builtin"] = {
        fg = "@indigo.200"
      },
      ["@property"] = {
        link = "Property"
      },
      ["@punctuation.bracket"] = {
        link = "Punctuation"
      },
      ["@lsp.type.variable"] = {
        link = "@variable"
      },
      Type = {
        fg = "@cyan.200"
      },
      Conditional = {
        fg = "@indigo.300"
      }
    },
    editor = {
      Search = {
        fg = "@foreground.50",
        bg = {
          opacity = 0.25,
          __xeno_opaque = true,
          fg = "@cyan.400"
        }
      },
      Visual = {
        bg = {
          opacity = 0.18,
          __xeno_opaque = true,
          fg = "@aurora.500"
        }
      },
      CursorLineNr = {
        bold = true,
        fg = "@frost.100"
      },
      CursorLine = {
        bg = {
          opacity = 0.06,
          __xeno_opaque = true,
          fg = "@teal.600"
        }
      },
      MatchParen = {
        bold = true,
        fg = "@frost.100"
      },
      IncSearch = {
        fg = "@background.950",
        bg = {
          opacity = 0.35,
          __xeno_opaque = true,
          fg = "@frost.300"
        }
      }
    }
  },
  integrations = {
    ghostty = {
      update_config = false,
      enabled = false
    }
  },
})
vim.g.colors_name = "polarized"
