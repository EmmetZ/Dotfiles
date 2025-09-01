local function augroup(name)
  return vim.api.nvim_create_augroup("vim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_attach"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buffer = args.buf
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buffer,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buffer,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- Set up global lsp keymaps
      local keys = require("plugins.utils.lsp_keymap").get()
      vim.iter(keys):each(function(m)
        if not m.deps or client:supports_method(m.deps) then
          local opts = { silent = true, buffer = buffer, desc = "LSP: " .. m.desc }
          vim.keymap.set(m.mode or "n", m[1], m[2], opts)
        end
      end)
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        require("snacks").toggle.inlay_hints():map("<leader>lh")
      end
      -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      --   vim.keymap.set("n", "<leader>lh", function()
      --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buffer })
      --   end, { buffer = buffer, desc = "LSP: Toggle Inlay Hints" })
      -- end

      -- disable semantic tokens
      if client:supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
      end

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
        end,
      })
    end
  end,
})
