return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true,
      contrast = "hard",
      overrides = {
        Function = { fg = "#83a598", bold = true },
        ["@function"] = { fg = "#83a598", bold = true },
        ["@lsp.type.function"] = { fg = "#83a598", bold = true },

        Type = { fg = "#fabd2f", bold = true },
        ["@type"] = { fg = "#fabd2f", bold = true },
        ["@lsp.type.enum"] = { fg = "#fabd2f", bold = true },

        Identifier = { fg = "#ebdbb2" },
        ["@variable"] = { fg = "#ebdbb2" },

        Constant = { fg = "#fe8019", bold = true },
        ["@constant"] = { fg = "#fe8019", bold = true },
        ["@lsp.type.enumMember"] = { fg = "#fe8019", bold = true },

        Special = { fg = "#d3869b", bold = true },
        ["@lsp.type.parameter"] = { fg = "#8ec07c" },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      })

      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, 1, {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return "no lsp"
          end

          local names = {}
          for _, client in ipairs(clients) do
            table.insert(names, client.name)
          end
          return table.concat(names, ",")
        end,
        icon = "LSP",
      })
    end,
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LazyFile",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "NvimTree",
          "notify",
          "snacks_dashboard",
          "trouble",
        },
      },
    },
  },
}
