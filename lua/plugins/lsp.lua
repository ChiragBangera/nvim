local function extend_unique(list, values)
  local seen = {}

  for _, item in ipairs(list) do
    seen[item] = true
  end

  for _, item in ipairs(values) do
    if not seen[item] then
      table.insert(list, item)
      seen[item] = true
    end
  end
end

local function find_project_python(root)
  if not root or root == "" then
    return nil
  end

  local candidates = {
    root .. "/.venv/bin/python",
    root .. "/venv/bin/python",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.pyright = vim.tbl_deep_extend("force", opts.servers.pyright or {}, {
        enabled = false,
      })

      opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
        before_init = function(_, config)
          local python = find_project_python(config.root_dir)
          if not python then
            return
          end

          config.settings = config.settings or {}
          config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
            pythonPath = python,
          })
        end,
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              autoSearchPaths = true,
              autoImportCompletions = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "standard",
            },
          },
        },
      })

      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
        init_options = {
          settings = {
            logLevel = "error",
            organizeImports = true,
          },
        },
      })

      opts.servers.yamlls = vim.tbl_deep_extend("force", opts.servers.yamlls or {}, {
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            validate = true,
            format = {
              enable = true,
            },
            schemaStore = {
              enable = true,
            },
            schemas = {
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                "docker-compose.yml",
                "docker-compose.yaml",
                "compose.yml",
                "compose.yaml",
              },
            },
          },
        },
      })

      opts.servers.sqls = vim.tbl_deep_extend("force", opts.servers.sqls or {}, {
        single_file_support = true,
      })

      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = {
          current_line = true,
          spacing = 2,
          source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      extend_unique(opts.ensure_installed, {
        "basedpyright",
        "ruff",
        "yaml-language-server",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      extend_unique(opts.ensure_installed, {
        "bash",
        "dockerfile",
        "json",
        "json5",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "toml",
        "vim",
        "yaml",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_organize_imports", "ruff_format" }
      opts.formatters_by_ft.rust = { "rustfmt" }
      opts.formatters_by_ft.toml = { "taplo" }
      opts.formatters_by_ft.yaml = { "prettier" }
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = { "python", "quarto" },
    cmd = "VenvSelect",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = { "python", "quarto" } },
    },
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        cached_venv_automatic_activation = true,
        notify_user_on_venv_activation = true,
        require_lsp_activation = false,
        set_environment_variables = true,
      })
    end,
  },
}
