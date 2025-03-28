print("advent of neovim")

require("config.lazy")

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>") -- source current file
vim.keymap.set("n", "<space>x", ":.lua<CR>")                -- run current line
vim.keymap.set("v", "<space>x", ":lua<CR>")                 -- run visually selected

-- Needed this line to show the text on lsp warnings/errors - appears not needed anymore once lspconfig is set up...
vim.diagnostic.config({ virtual_text = true })

-- Highlight when yanking (copying) text
-- Try it with 'yap' in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
