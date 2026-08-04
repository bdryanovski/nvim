vim.pack.add({
    'https://github.com/utilyre/barbecue.nvim',
    'https://github.com/SmiteshP/nvim-navic',
})

-- triggers CursorHold event faster
vim.opt.updatetime = 200

require('barbecue').setup({
    create_autocmd = false, -- prevent barbecue from updating itself automatically
    kinds = {
        File = '',
        Module = '',
        Namespace = '',
        Package = '',
        Class = '',
        Method = '',
        Property = '',
        Field = '',
        Constructor = '',
        Enum = '',
        Interface = '',
        Function = '',
        Variable = '',
        Constant = '',
        String = '',
        Number = '',
        Boolean = '',
        Array = '',
        Object = '',
        Key = '',
        Null = '',
        EnumMember = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
    },
})

-- configurations go here
vim.api.nvim_create_autocmd({
    'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
    'BufWinEnter',
    'CursorHold',
    'InsertLeave',
}, {
    group = vim.api.nvim_create_augroup('barbecue.updater', {}),
    callback = function()
        require('barbecue.ui').update()
    end,
})
