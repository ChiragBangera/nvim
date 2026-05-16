local function rust_analyzer_cmd()
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
  if vim.fn.executable(mason_bin) == 1 then
    return { mason_bin }
  end

  return { "rust-analyzer" }
end

local function install_lsp_restart_bridge()
  vim.api.nvim_create_user_command("LspRestart", function(info)
    local names = info.fargs
    if #names == 0 then
      names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()

      if #names == 0 and vim.bo.filetype == "rust" then
        names = { "rust-analyzer" }
      end
    end

    local lspconfig_names = {}
    for _, name in ipairs(names) do
      if name == "rust-analyzer" or name == "rust_analyzer" then
        if vim.fn.exists(":RustAnalyzer") == 2 then
          vim.cmd.RustAnalyzer("restart")
        else
          vim.notify("RustAnalyzer command is not available yet", vim.log.levels.WARN)
        end
      else
        table.insert(lspconfig_names, name)
      end
    end

    for _, name in ipairs(lspconfig_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name), vim.log.levels.WARN)
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end

    if #lspconfig_names > 0 then
      local timer = assert(vim.uv.new_timer())
      timer:start(500, 0, function()
        timer:close()
        for _, name in ipairs(lspconfig_names) do
          vim.schedule_wrap(vim.lsp.enable)(name)
        end
      end)
    end
  end, {
    bang = true,
    desc = "Restart LSP clients, delegating rust-analyzer to rustaceanvim",
    nargs = "*",
    complete = function(arg)
      local seen = {}
      local names = {}

      for _, client in ipairs(vim.lsp.get_clients()) do
        if not seen[client.name] then
          table.insert(names, client.name)
          seen[client.name] = true
        end
      end

      for name, _ in pairs(vim.lsp.config._configs or {}) do
        if not seen[name] then
          table.insert(names, name)
          seen[name] = true
        end
      end

      return vim
        .iter(names)
        :filter(function(name)
          return name:sub(1, #arg) == arg
        end)
        :totable()
    end,
  })
end

return {
  {
    "mrcjkb/rustaceanvim",
    init = function()
      -- rustaceanvim uses the client name "rust-analyzer". Defining it here
      -- avoids noisy Neovim 0.11 warnings when the plugin probes vim.lsp.config.
      vim.lsp.config("rust-analyzer", {
        cmd = rust_analyzer_cmd(),
      })

      -- rust-analyzer may ask clients to refresh pull diagnostics. Neovim 0.11
      -- does not implement this request, so reply successfully instead of
      -- logging repeated "no handler found" warnings.
      vim.lsp.handlers["workspace/diagnostic/refresh"] = vim.lsp.handlers["workspace/diagnostic/refresh"]
        or function()
          return vim.NIL
        end
    end,
    opts = function(_, opts)
      opts = opts or {}
      opts.server = opts.server or {}
      opts.server.cmd = rust_analyzer_cmd

      install_lsp_restart_bridge()

      opts.server.default_settings = vim.tbl_deep_extend("force", opts.server.default_settings or {}, {
        ["rust-analyzer"] = {
          cfg = {
            setTest = false,
          },
          cargo = {
            target = "thumbv7em-none-eabihf",
            allTargets = false,
          },
          check = {
            allTargets = false,
          },
        },
      })

      return opts
    end,
  },
}
