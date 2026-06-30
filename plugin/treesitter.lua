vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

local ok_context, ts_context = pcall(require, 'nvim-treesitter-context')
if ok_context then
    ts_context.setup({
        multiwindow = true,
        line_numbers = false,
        multiline_threshold = 2,
    })
end

local ok_ts, treesitter = pcall(require, 'nvim-treesitter')
if not ok_ts then
    vim.notify('nvim-treesitter not found', vim.log.levels.WARN)
    return
end

treesitter.install({
    'vim',
    'lua',
    'markdown',
    'markdown_inline',
    'query',
    'regex',
    'json',
    'javascript',
    'typescript',
    'tsx',
    'go',
    'yaml',
    'html',
    'css',
    'python',
    'http',
    'graphql',
    'bash',
    'dockerfile',
    'gitignore',
    'vimdoc',
    'prisma',
    'c',
    'rust',
})

vim.filetype.add({
    extension = {
        mdx = 'mdx',
    },
})
vim.treesitter.language.register('markdown', 'mdx')

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        local ok_add = pcall(vim.treesitter.language.add, lang)
        if not ok_add then
            return
        end

        -- start treesitter safely
        pcall(vim.treesitter.start, buf, lang)

        -- enable indentation (skip yaml/markdown)
        if ft ~= 'yaml' and ft ~= 'markdown' then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.bo[buf].smartindent = false
            vim.bo[buf].cindent = false
        end
    end,
})

treesitter.setup()
