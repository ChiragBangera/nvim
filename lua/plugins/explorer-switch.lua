return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false }, -- disable default
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle NvimTree" })
    end,
  },
}
