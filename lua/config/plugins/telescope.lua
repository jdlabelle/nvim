return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',
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

    require('telescope').load_extension('fzf')

    vim.keymap.set("n", "<leader>fh", require('telescope.builtin').help_tags, { desc = 'Telescope [F]ind [H]elp' })
    vim.keymap.set("n", "<leader>ff", require('telescope.builtin').find_files, { desc = 'Telescope [F]ind [F]iles' })
    vim.keymap.set("n", "<leader>fa", function()
      require('telescope.builtin').find_files({ follow = true, hidden = true, no_ignore = true })
    end, { desc = 'Telescope [F]ind [A]ll Files' })

    vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers,
      { desc = 'Telescope [F]ind existing [B]uffers' })

    vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string,
      { desc = 'Telescope [F]ind current [W]ord under cursor' })

    vim.keymap.set('n', '<leader>fo', function()
      require('telescope.builtin').find_files {
        cwd = '~/wiki'
      }
    end, { desc = 'Telescope [F]ind [O]bsidian notes' })

    vim.keymap.set("n", "<leader>fn", function()
      require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath("config")
      }
    end, { desc = 'Telescope [F]ind [N]eovim config files' })

    vim.keymap.set("n", "<leader>fp", function()
      require('telescope.builtin').find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
      }
    end, { desc = 'Telescope [F]ind in [P]lugins' })
    require "config.telescope.multigrep".setup()
  end
}
