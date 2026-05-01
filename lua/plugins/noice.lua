return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.cmdline = opts.cmdline or {}
      opts.cmdline.format = opts.cmdline.format or {}
      opts.cmdline.format.cmdline = vim.tbl_deep_extend("force", opts.cmdline.format.cmdline or {}, {
        -- Avoid Tree-sitter highlight errors when the installed `vim` parser
        -- lags behind the query version used by nvim-treesitter.
        lang = false,
      })
    end,
  },
}
