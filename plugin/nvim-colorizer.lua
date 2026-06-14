vim.pack.add({
    'https://github.com/catgoose/nvim-colorizer.lua',
})

require('colorizer').setup({
    user_commands = true,
    options = {
        display = {

            mode = 'virtualtext',
            virtualtext = { position = 'after' },
        },

        parsers = {
            hex = {
                enable = true,
                rrggbb = true,
                rgb = true,
                rgba = true,
                rrggbbaa = true,
            },
            css = true,
        },
    },
    filetypes = {
        'html',
        'css',
        'javascript',
        'typescript',
        'typescriptreact',
        'javascriptreact',
        'lua',
    },
})
