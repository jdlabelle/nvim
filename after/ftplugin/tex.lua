local set = vim.opt_local

set.shiftwidth = 2
set.tabstop = 2
set.expandtab = true
set.colorcolumn = "80"
--set.wrap = true
--set.linebreak = true
vim.keymap.set('n', '<leader>wc', '<cmd>VimtexCountWords!<CR>',
  { buffer = true, desc = 'Vimtex Word Count' })
set.textwidth = 79
set.formatoptions:append("t")
-- Enable spell checking only for spellable regions (like text, not code/math)
set.spell = true
set.spelllang = { 'en_us' }
