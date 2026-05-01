-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local prose_group = vim.api.nvim_create_augroup("user_prose_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = prose_group,
  pattern = { "gitcommit", "markdown", "quarto", "text" },
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})
