return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Define per server configs
      vim.lsp.config("lua_ls", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })

      -- Enable the servers
      vim.lsp.enable({ "lua_ls", "pyright" })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback =
            function(args)
              local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
              if not client then return end

              -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
              if not client:supports_method('textDocument/willSaveWaitUntil')
                  and client:supports_method('textDocument/formatting') then
                vim.api.nvim_create_autocmd('BufWritePre', {
                  group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                  buffer = args.buf,
                  callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                  end,
                })
              end

              local map = function(keys, func, desc, mode)
                mode = mode or 'n'
                vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
              end

              -- Rename the variable under your cursor.
              --  Most Language Servers support renaming across files, etc.
              map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

              -- Execute a code action, usually your cursor needs to be on top of an error
              -- or a suggestion from your LSP for this to activate.
              map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

              -- Find references for the word under your cursor.
              map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

              -- Jump to the implementation of the word under your cursor.
              --  Useful when your language has ways of declaring types without an actual implementation.
              map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

              -- Jump to the definition of the word under your cursor.
              --  This is where a variable was first declared, or where a function is defined, etc.
              --  To jump back, press <C-t>.
              map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

              -- WARN: This is not Goto Definition, this is Goto Declaration.
              --  For example, in C this would take you to the header.
              map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

              -- Fuzzy find all the symbols in your current document.
              --  Symbols are things like variables, functions, types, etc.
              map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

              -- Fuzzy find all the symbols in your current workspace.
              --  Similar to document symbols, except searches over your entire project.
              map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

              -- Jump to the type of the word under your cursor.
              --  Useful when you're not sure what type a variable is and you want to see
              --  the definition of its *type*, not where it was *defined*.
              map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
            end,
      })
      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
    end,
  }
}
