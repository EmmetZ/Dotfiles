return {
  'nvim-lualine/lualine.nvim',
  config = function()
    local palette = require("catppuccin.palettes").get_palette "macchiato"
    local M = {}
    M.conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.o.columns > 100
      end,
      has_lsp_clients = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        return #clients > 0
      end,
    }
    require('lualine').setup({
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_b = {
          "branch",
          -- {
          --   "diff",
          --   symbols = {
          --     added    = " ",
          --     modified = " ",
          --     removed  = " ",
          --   },
          --   source = function()
          --     local gitsigns = vim.b.gitsigns_status_dict
          --     if gitsigns then
          --       return {
          --         added = gitsigns.added,
          --         modified = gitsigns.changed,
          --         removed = gitsigns.removed,
          --       }
          --     end
          --   end,
          -- },
          "diagnostics"
        },
        lualine_c = {
          {
            "filename",
            separator = { left = "" }
          },
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then return "" end -- not recording
              return "recording @" .. reg
            end,
            color = { fg = palette.subtext0 },
          }
        },
        lualine_x = {
          -- {
          --   require("noice").api.status.search.get,
          --   cond = require("noice").api.status.search.has,
          --   color = { fg = "#ff9e64" },
          --   separator = { right = '' }
          -- },
          {
            function()
              local clients = {}
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              for _, client in pairs(buf_clients) do
                table.insert(clients, client.name)
              end

              return string.format("LSP(s):[%s]", table.concat(clients, " • "))
            end,
            icon = "",
            color = { fg = palette.mauve },
            cond = M.conditions.hide_in_width and M.conditions.has_lsp_clients,
            separator = { right = '' },
          },
          "encoding", "filetype" },
      }
    })
  end
}
