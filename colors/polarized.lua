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
    aurora = "#3ddc97",
    violet = "#9b7fd4",
    cyan = "#4fd9e8",
    frost = "#a8e6cf",
    teal = "#2ec4b6",
    glow_pink = "#e39fc2",
    ice = "#8ecae6",
    indigo = "#7c93e0"
  },
  highlights = {
    editor = {
      Visual = {
        bg = {
          __xeno_opaque = true,
          fg = "@aurora.500",
          opacity = 0.18
        }
      },
      CursorLine = {
        bg = {
          __xeno_opaque = true,
          fg = "@teal.600",
          opacity = 0.06
        }
      },
      MatchParen = {
        fg = "@frost.100",
        bold = true
      },
      CursorLineNr = {
        fg = "@frost.100",
        bold = true
      },
      Search = {
        fg = "@foreground.50",
        bg = {
          __xeno_opaque = true,
          fg = "@cyan.400",
          opacity = 0.25
        }
      },
      IncSearch = {
        fg = "@background.950",
        bg = {
          __xeno_opaque = true,
          fg = "@frost.300",
          opacity = 0.35
        }
      }
    },
    syntax = {
      Function = {
        fg = "@teal.300"
      },
      Operator = {
        fg = "@cyan.300"
      },
      Number = {
        fg = "@frost.100"
      },
      Boolean = {
        fg = "@frost.100"
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
      Keyword = {
        fg = "@violet.300"
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
      Type = {
        fg = "@cyan.200"
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
      ["@operator"] = {
        link = "Operator"
      },
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      ["@variable.builtin"] = {
        fg = "@indigo.200"
      },
      ["@constant.builtin"] = {
        fg = "@glow_pink.100",
        bold = true
      },
      ["@constant"] = {
        fg = "@frost.200"
      },
      Conditional = {
        fg = "@indigo.300"
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
      ["@variable"] = {
        link = "Variable"
      },
      ["@keyword.operator"] = {
        fg = "@cyan.300"
      },
      ["@lsp.type.function"] = {
        link = "@function"
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
      Property = {
        fg = "@ice.300"
      },
      Variable = {
        fg = "@foreground.300"
      },
      Comment = {
        italic = true,
        fg = "@foreground.400"
      },
      String = {
        fg = "@aurora.100"
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
