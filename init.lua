local function pick_python_host()
  local candidates = {
    vim.env.NVIM_PYTHON3_HOST_PROG,
    vim.fn.stdpath("data") .. "/python-host/bin/python",
  }

  for _, path in ipairs(candidates) do
    if path and path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

local python_host = pick_python_host()
if python_host then
  local host_bin = vim.fn.fnamemodify(python_host, ":h")
  vim.env.PATH = host_bin .. ":" .. vim.env.PATH
  vim.g.python3_host_prog = python_host
end

-- Prefer basedpyright over pyright for Python projects.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
