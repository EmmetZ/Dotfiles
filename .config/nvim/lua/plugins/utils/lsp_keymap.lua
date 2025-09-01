local M = {}
M._keys = nil
-- local theme = require("telescope.themes").get_cursor({
--   prompt = false,
--   layout_config = {
--     width = math.floor(vim.o.columns * 0.9),
--     preview_width = 0.6,
--   },
--   show_line = false
-- })
-- local builtin = require("telescope.builtin")
local Snacks = require("snacks")

function M.get()
  if not M._keys then
    -- stylua: ignore
    M._keys = {
      -- { "gd", function() builtin.lsp_definitions(theme) end, desc = "Goto Definition", deps = "textDocument/definition" },
      -- { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", deps = "textDocument/declaration" },
      -- { "gr", function() builtin.lsp_references(theme) end, desc = "Goto References", deps = "textDocument/references" },
      -- { "gi", function() builtin.lsp_implementations(theme) end, desc = "goto implementation", deps = "textDocument/documentSymbol" },
      -- { "<leader>D", builtin.lsp_type_definitions, desc = "Goto Type Definition", deps = "textDocument/definition" },
      -- { "<leader>fo", builtin.lsp_document_symbols, desc = "Find Object", deps = "textDocument/documentSymbols" },

      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "gh", function() return vim.lsp.buf.hover() end, desc = "Hover", deps = "textDocument/hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", deps = "textDocument/rename"  },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, deps = "textDocument/codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, deps = "textDocument/codeLens" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, deps = "textDocument/codeAction" },
      { "<leader>cA", function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {}}}) end, desc = "Source Action", deps = "textDocument/codeAction" },
      -- { "<leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle inlay hint", deps = "textDocument/inlayHint" },
    }
  end
  return M._keys
end

return M
