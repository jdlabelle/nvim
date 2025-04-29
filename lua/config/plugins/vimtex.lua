return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    config = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura_simple"
      vim.g.vimtex_quickfix_open_on_warning = 0

      local au_group = vim.api.nvim_create_augroup("vimtex_events", {})
      -- Cleanup on quit (change to VimtexClean! to also remove output files)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventQuit",
        group = au_group,
        command = "VimtexClean"
      })
    end
  }
}
