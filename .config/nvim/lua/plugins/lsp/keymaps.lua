local M = {}
M._keys = nil
local theme = require("telescope.themes").get_cursor({
  prompt = false,
})
local builtin = require("telescope.builtin")

function M.get()
  if not M._keys then
    -- stylua: ignore
    M._keys = {
      { "gd", function() builtin.lsp_definitions(theme) end, desc = "Goto Definition", deps = "textDocument/definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", deps = "textDocument/declaration" },
      { "gr", function() builtin.lsp_references(theme) end, desc = "Goto References", deps = "textDocument/references" },
      { "gi", function() builtin.lsp_implementations(theme) end, desc = "goto implementation", deps = "textDocument/documentSymbol" },
      { "<leader>D", builtin.lsp_type_definitions, desc = "Goto Type Definition", deps = "textDocument/definition" },
      { "<leader>fo", builtin.lsp_document_symbols, desc = "Find Object", deps = "textDocument/documentSymbols" },
      { "gh", function() return vim.lsp.buf.hover() end, desc = "Hover", deps = "textDocument/hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", deps = "textDocument/rename"  },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, deps = "textDocument/codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, deps = "textDocument/codeLens" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, deps = "textDocument/codeAction" },
      { "<leader>cA", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {}}}) end, desc = "Source Action", desp = "textDocument/codeAction" },
      { "<leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle inlay hint", desp = "textDocument/inlayHint" },
    }
  end
  return M._keys
end

return M
