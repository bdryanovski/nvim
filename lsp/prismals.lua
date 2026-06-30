return {
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/prisma-language-server', '--stdio' },
    filetypes = { 'prisma' },
    settings = {
        prisma = {
            prismaFmtBinPath = '',
        },
    },
    root_markers = { '.git', 'package.json', 'schema.prisma' },
}
