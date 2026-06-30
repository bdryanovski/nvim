vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
})

local ok_mason, mason = pcall(require, 'mason')
if not ok_mason then
    return
end

mason.setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
})

local ok_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
if ok_lspconfig then
    mason_lspconfig.setup({
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
end

local ok_installer, mason_installer = pcall(require, 'mason-tool-installer')
if ok_installer then
    mason_installer.setup({
        ensure_installed = {
            'prettier',
            'stylua',
            'clangd',
            'oxlint',
        },
    })
end
