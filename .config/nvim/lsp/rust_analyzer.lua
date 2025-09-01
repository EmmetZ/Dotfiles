vim.lsp.config("rust_analyzer", {
  cmd = { "/home/baiyx/.vscode/extensions/rust-lang.rust-analyzer-0.3.2547-linux-x64/server/rust-analyzer" },
  ft = { "rust" },
  on_attach = function()
    vim.lsp.inlay_hint.enable(true)
    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
      local default_diagnostic_handler = vim.lsp.handlers[method]
      vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
          return
        end
        return default_diagnostic_handler(err, result, context, config)
      end
    end
    vim.keymap.set("n", "<leader>co", function()
      vim.lsp.buf.code_action({
        context = {
          only = { "source.rust-analyzer.organize-imports" },
          diagnostics = {},
        },
      })
    end, { desc = "LSP: Organize Imports" })
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
