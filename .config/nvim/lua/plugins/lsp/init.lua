-- turn off lsp log
vim.lsp.set_log_level("off")

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls" },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --   { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
    --   "williamboman/mason-lspconfig.nvim",
    --   "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- },
    config = function()
      local servers = require("plugins.lsp.servers")

      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      -- require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      local function setup_lsp(server_name)
        local m = require("plugins.lsp.methods")
        local server = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for ts_ls)
        server.capabilities = vim.tbl_deep_extend("force", {}, m.capabilities, server.capabilities or {})
        local _on_attach = server.on_attach
        server.on_attach = function(client, buffer)
          if server.keys then
            require("plugins.lsp.methods").setup_keymaps(server.keys, buffer)
          end
          require("plugins.lsp.methods").on_attach(client, buffer)
          if _on_attach then
            _on_attach(client, buffer)
          end
        end
        server.on_init = m.on_init
        require("lspconfig")[server_name].setup(server)
      end

      require("mason-lspconfig").setup {
        handlers = { setup_lsp },
      }

      setup_lsp('tinymist')
      setup_lsp('clangd')
      setup_lsp('rust_analyzer')
    end,
  },
}
