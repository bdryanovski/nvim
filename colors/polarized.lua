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
    aurora = "#3ddc97",
    cyan = "#4fd9e8",
    ice = "#8ecae6",
    violet = "#9b7fd4",
    indigo = "#7c93e0",
    frost = "#a8e6cf",
    glow_pink = "#e39fc2"
  },
  highlights = {
    syntax = {
      Type = {
        fg = "@cyan.200"
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
      Number = {
        fg = "@frost.100"
      },
      Function = {
        fg = "@teal.300"
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
      ["@lsp.type.variable"] = {
        link = "@variable"
      },
      ["@variable"] = {
        link = "Variable"
      },
      Variable = {
        fg = "@foreground.300"
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
      ["@operator"] = {
        link = "Operator"
      },
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      ["@variable.builtin"] = {
        fg = "@indigo.200"
      },
      Property = {
        fg = "@ice.300"
      },
      Boolean = {
        fg = "@frost.100"
      },
      ["@constant.builtin"] = {
        bold = true,
        fg = "@glow_pink.100"
      },
      ["@constant"] = {
        fg = "@frost.200"
      },
      ["@string.escape"] = {
        fg = "@ice.100"
      },
      ["@boolean"] = {
        link = "Boolean"
      },
      ["@number"] = {
        link = "Number"
      },
      Comment = {
        fg = "@foreground.400",
        italic = true
      },
      Keyword = {
        fg = "@violet.300"
      },
      ["@string"] = {
        link = "String"
      },
      ["@function.builtin"] = {
        fg = "@cyan.100"
      },
      ["@punctuation.delimiter"] = {
        link = "Punctuation"
      },
      ["@keyword.import"] = {
        fg = "@teal.400"
      },
      String = {
        fg = "@aurora.100"
      },
      ["@keyword.operator"] = {
        fg = "@cyan.300"
      },
      Operator = {
        fg = "@cyan.300"
      },
      Conditional = {
        fg = "@indigo.300"
      }
    },
    editor = {
      CursorLineNr = {
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
      },
      MatchParen = {
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
      Visual = {
        bg = {
          opacity = 0.18,
          __xeno_opaque = true,
          fg = "@aurora.500"
        }
      },
      Search = {
        fg = "@foreground.50",
        bg = {
          opacity = 0.25,
          __xeno_opaque = true,
          fg = "@cyan.400"
        }
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
