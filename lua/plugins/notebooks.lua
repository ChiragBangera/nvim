local function quarto_runner(method)
  return function()
    require("quarto.runner")[method]()
  end
end

return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = function()
      local has_quarto = vim.fn.executable("quarto") == 1
      return {
        force_ft = has_quarto and "quarto" or "markdown",
        output_extension = has_quarto and "qmd" or "md",
      }
    end,
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    cmd = {
      "MoltenDelete",
      "MoltenEnterOutput",
      "MoltenEvaluateLine",
      "MoltenEvaluateOperator",
      "MoltenEvaluateVisual",
      "MoltenHideOutput",
      "MoltenImportOutput",
      "MoltenInit",
      "MoltenInterrupt",
      "MoltenReevaluateCell",
      "MoltenShowOutput",
    },
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_image_provider = "none"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_max_lines = 12
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>ni", "<cmd>MoltenInit<cr>", desc = "Notebook Init Kernel", ft = { "markdown", "python", "quarto" } },
      {
        "<leader>nl",
        "<cmd>MoltenEvaluateLine<cr>",
        desc = "Notebook Run Line",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>no",
        "<cmd>noautocmd MoltenEnterOutput<cr>",
        desc = "Notebook Open Output",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>nh",
        "<cmd>MoltenHideOutput<cr>",
        desc = "Notebook Hide Output",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>nR",
        "<cmd>MoltenReevaluateCell<cr>",
        desc = "Notebook Re-run Cell",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>nx",
        "<cmd>MoltenInterrupt<cr>",
        desc = "Notebook Interrupt",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>nd",
        "<cmd>MoltenDelete<cr>",
        desc = "Notebook Delete Cell Output",
        ft = { "markdown", "python", "quarto" },
      },
      {
        "<leader>nr",
        ":<C-u>MoltenEvaluateVisual<cr>gv",
        desc = "Notebook Run Selection",
        ft = { "markdown", "python" },
        mode = "v",
      },
    },
  },
  {
    "jmbuhr/otter.nvim",
    lazy = true,
  },
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
      "benlubas/molten-nvim",
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      closePreviewOnExit = true,
      codeRunner = {
        default_method = "molten",
        enabled = true,
        never_run = { "yaml" },
      },
      lspFeatures = {
        chunks = "curly",
        completion = {
          enabled = true,
        },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost", "InsertLeave" },
        },
        enabled = true,
        languages = { "bash", "html", "python", "sql", "yaml" },
      },
    },
    keys = {
      { "<leader>np", "<cmd>QuartoPreview<cr>", desc = "Notebook Preview", ft = "quarto" },
      { "<leader>nr", quarto_runner("run_cell"), desc = "Notebook Run Cell", ft = "quarto" },
      { "<leader>na", quarto_runner("run_all"), desc = "Notebook Run All", ft = "quarto" },
      { "<leader>nb", quarto_runner("run_above"), desc = "Notebook Run Above", ft = "quarto" },
      { "<leader>nf", quarto_runner("run_below"), desc = "Notebook Run Below", ft = "quarto" },
      { "<leader>nr", quarto_runner("run_range"), desc = "Notebook Run Selection", ft = "quarto", mode = "v" },
    },
  },
}
