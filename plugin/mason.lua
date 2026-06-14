vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/neovim/nvim-lspconfig',
})

require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
})

require('mason-lspconfig').setup({
    automatic_enable = false,
    -- servers for mason to install
    ensure_installed = {
        'lua_ls',
        'ts_ls',
        'html',
        'cssls',
        'gopls',
        'astro',
        'marksman',
    },
})

require('mason-tool-installer').setup({
    ensure_installed = {
        'prettier',
        'stylua',
        'clangd',
        'oxlint',
    },
})
