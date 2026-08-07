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
    cyan = "#4fd9e8",
    frost = "#a8e6cf",
    glow_pink = "#e39fc2",
    ice = "#8ecae6",
    indigo = "#7c93e0",
    teal = "#2ec4b6",
    violet = "#9b7fd4",
    aurora = "#3ddc97"
  },
  highlights = {
    editor = {
      MatchParen = {
        bold = true,
        fg = "@frost.100"
      },
      CursorLineNr = {
        bold = true,
        fg = "@frost.100"
      },
      Search = {
        fg = "@foreground.50",
        bg = {
          fg = "@cyan.400",
          opacity = 0.25,
          __xeno_opaque = true
        }
      },
      IncSearch = {
        fg = "@background.950",
        bg = {
          fg = "@frost.300",
          opacity = 0.35,
          __xeno_opaque = true
        }
      },
      Visual = {
        bg = {
          fg = "@aurora.500",
          opacity = 0.18,
          __xeno_opaque = true
        }
      },
      CursorLine = {
        bg = {
          fg = "@teal.600",
          opacity = 0.06,
          __xeno_opaque = true
        }
      }
    },
    syntax = {
      Keyword = {
        fg = "@violet.300"
      },
      Comment = {
        italic = true,
        fg = "@foreground.400"
      },
      Type = {
        fg = "@cyan.200"
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
      Function = {
        fg = "@teal.300"
      },
      ["@variable.builtin"] = {
        fg = "@indigo.200"
      },
      Operator = {
        fg = "@cyan.300"
      },
      ["@constant.builtin"] = {
        bold = true,
        fg = "@glow_pink.100"
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
      Variable = {
        fg = "@foreground.300"
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
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      Boolean = {
        fg = "@frost.100"
      },
      Property = {
        fg = "@ice.300"
      },
      String = {
        fg = "@aurora.100"
      },
      Conditional = {
        fg = "@indigo.300"
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
