vim.api.nvim_create_user_command('PackDel', function(opts)
    vim.pack.del(opts.fargs)
end, {
    nargs = '+',
    desc = 'Delete plugins (:PackDel plugin1 plugin 2)',
})

vim.api.nvim_create_user_command('PackUpdate', function(opts)
    if opts.args:match('%S') then
        local plugin = vim.split(opts.args, '%s+', { trimempty = true })
        vim.pack.update(plugin)
    else
        vim.pack.update()
    end
end, {
    nargs = '*',
    desc = 'Update all Pack plugins or all of them',
})
