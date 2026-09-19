return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- Change an existing keymap
          {
            "gh",
            function()
              return vim.lsp.buf.hover()
            end,
            desc = "Hover",
          },
          -- Disable a keymap
          { "K", false },
        },
      },
    },
  },
}
