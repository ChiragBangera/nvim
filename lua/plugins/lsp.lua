return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- Ruff LSP for linting and formatting
      require("lspconfig").ruff_lsp.setup({
        init_options = {
          settings = {
            -- Enable all Ruff rules
            args = {
              "--select=ALL", -- Enable all available rules
              "--ignore=E501", -- Ignore line too long (optional)
            },
          },
        },
      })

      -- Basedpyright for type checking and more diagnostics
      require("lspconfig").basedpyright.setup({
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "standard", -- or "strict" for even more warnings
              reportUnusedImport = true,
              reportUnusedClass = true,
              reportUnusedFunction = true,
              reportUnusedVariable = true,
              reportDuplicateImport = true,
              reportOptionalSubscript = true,
              reportOptionalMemberAccess = true,
            },
          },
        },
      })

      -- Make sure diagnostics are enabled and visible
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
}
