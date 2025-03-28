return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    require('telescope').setup {
      pickers = {
        find_files = {
          theme = "ivy"
        }
      },
      extensions = {
        fzf = {}
      }
    }
    vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, { desc = 'Telescope search help' })
    vim.keymap.set("n", "<leader>fd", require('telescope.builtin').find_files, { desc = 'Telescope find files' })
    vim.keymap.set("n", "<leader>en", function()
      require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath("config")
      }
    end, { desc = 'find nvim config files' })
  end
}
