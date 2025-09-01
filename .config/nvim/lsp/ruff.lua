return {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "error",
      lint = {
        enable = true,
        preview = true,
      },
      organizeImports = true,
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
    if client.supports_method("textDocument/codeAction") then
      vim.keymap.set("n", "<leader>co", function()
        vim.lsp.buf.code_action(
          {
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          }
        )
      end, { desc = "Organize Imports" })
    end
  end,
}
