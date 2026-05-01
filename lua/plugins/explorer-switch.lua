return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false }, -- disable default
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
      { "<leader>E", "<cmd>NvimTreeToggle %:p:h<cr>", desc = "Explorer Current File" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      actions = {
        change_dir = {
          enable = true,
          global = false,
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        enable = true,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
    },
  },
}
