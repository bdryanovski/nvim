-- monoz palette
-- Forked from monoglow.nvim `z` style. Grayscale base plus a muted accent set.

---@class Palette
---@field git GitColors
---@field special? SpecialColors
local ret = {
    gray1 = '#080808',
    gray2 = '#191919',
    gray3 = '#2a2a2a',
    gray4 = '#444444',
    gray5 = '#555555',
    gray6 = '#7a7a7a',
    gray7 = '#aaaaaa',
    gray8 = '#cccccc',
    gray9 = '#dddddd',
    gray10 = '#f1f1f1',
    white = '#ffffff',

    fg = '#cccccc',
    bg = '#121212',
    glow = '#1bfd9c',

    blue1 = '#b2d8d8',
    blue2 = '#66b2b2',

    -- NOTE: kept as a tribute to lackluster
    lack = '#708090',
    luster = '#deeeed',

    git = {
        add = '#baffc9',
        change = '#ffffba',
        delete = '#ffb3ba',
    },

    -- Nvim*
    light_blue = '#a6dbff', -- NvimLightBlue
    light_cyan = '#8cf8f7', -- NvimLightCyan
    light_green = '#b3f6c0', -- NvimLightGreen
    light_magenta = '#ffcaff', -- NvimLightMagenta
    light_red = '#ffc0b9', -- NvimLightRed
    light_yellow = '#fce094', -- NvimLightYellow

    -- Named accent palette. Muted tones tuned for the #121212 background.
    -- Reference these by name in the `syntax` config to colorize a syntax role.
    -- e.g. require("bdryanovski.monoz").setup({ syntax = { keyword = "purple" } })
    accents = {
        red = '#e06c75',
        orange = '#d19a66',
        yellow = '#e5c07b',
        green = '#98c379',
        teal = '#66b2b2',
        cyan = '#8cf8f7',
        blue = '#a6dbff',
        purple = '#c3a6ff',
        magenta = '#ffcaff',
        pink = '#fd1b7c',
        glow = '#1bfd9c',
    },
}

return ret
