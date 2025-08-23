print("advent of neovim")

require("config.lazy")

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = false

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Jump forward to the next item in quickfix" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "Jump backward to the previous item in quickfix" })
vim.keymap.set("n", "<leader>qf", ":lua vim.diagnostic.setqflist()<CR>",
  { desc = "Set the quickfix list with all diagnostic issues from buffers" })

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", ",v", "<C-v>", { desc = "Visual block mode for WSL" })
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>") -- source current file
vim.keymap.set("n", "<space>x", ":.lua<CR>")                -- run current line
vim.keymap.set("v", "<space>x", ":lua<CR>")                 -- run visually selected

-- easy buffer switching
vim.keymap.set("n", "<leader>n", "<cmd>bn<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>b", "<cmd>bp<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>d", "<cmd>bd<CR>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>l", "<cmd>ls<CR>", { desc = "List Buffers" })

-- Keep cursor in middle of screen when scrolling with Ctrl+d/Ctrl+u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Needed this line to show the text on lsp warnings/errors, this is now handled in lsp.lua
--vim.diagnostic.config({ virtual_text = true })

-- Highlight when yanking (copying) text
-- Try it with 'yap' in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})


-- Neovim Terminal Stuff
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Open the built-in nvim terminal in the specified format
local job_id = 0
vim.keymap.set("n", "<leader>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
  job_id = vim.bo.channel   -- goes with below
end, { desc = "Open built-in nvim terminal" })

-- Run a custom command in the nvim terminal (you can be in a different window)
vim.keymap.set("n", "<leader>tr", function()
  -- make, python test, etc
  -- some bash command to run
  vim.fn.chansend(job_id, { "tree .\r\n" })
end, { desc = "Run custom terminal command" })

vim.keymap.set("t", "<leader>tx", "<C-\\><C-N>", { desc = "Exit built-in terminal" })


-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
