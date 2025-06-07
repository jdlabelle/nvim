return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
  },
  vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" }),

  vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" }),

  vim.keymap.set("n", "<leader>tq", ":TodoQuickFix<CR>",
    { desc = "[T]ODO [Q]uickFix" }),

  vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>",
    { desc = "Telescope [F]ind [T]ODO" }),
}
