vim.treesitter.start()

vim.opt_local.conceallevel = 1
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
vim.opt.foldlevel = 99
