vim.lsp.config("tinymist", {
  single_file_support = true,
  -- offset_encoding = "utf-8",
  --- See [Tinymist Server Configuration](https://github.com/Myriad-Dreamin/tinymist/blob/main/Configuration.md) for references.
  settings = {
    formatterMode = 'typstyle',
    semanticTokens = "disable",
    -- exportPdf = "onType",
  },
  on_attach = function(client, _)
    if client then
      vim.keymap.set("n", "<leader>mc", function()
        local path = vim.api.nvim_buf_get_name(0)
        -- vim.notify(string.format("compiling %s", path), vim.log.levels.INFO)
        vim.fn.system(string.format("typst compile %s", path))
        if vim.v.shell_error == 0 then
          local pdf_path = path:gsub("%.typ$", ".pdf")
          vim.notify("success: " .. pdf_path, vim.log.levels.INFO)
        else
          vim.notify(string.format("compile error"), vim.log.levels.ERROR)
        end
      end, { desc = "Typst compile pdf" })
    end
  end
})
