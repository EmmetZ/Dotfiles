return {
  'nvim-lualine/lualine.nvim',
  opts = function()
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
      hide_lsp = function()
        local width_flag = M.conditions.hide_in_width()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local flag = #clients > 0 and width_flag
        return flag
      end
    }
    local opts = {
      options = {
        theme = 'catppuccin',
        globalstatus = true,
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added    = " ",
              modified = " ",
              removed  = " ",
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            cond = M.conditions.hide_lsp,
          },
          "diagnostics"
        },
        lualine_c = {
          {
            "filename",
            separator = { left = "" },
            symbols = {
              modified = '', -- Text to show when the file is modified.
              readonly = ' ', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
            color = function()
              if vim.bo.modified then
                return { fg = palette.yellow }
              else
                return { fg = palette.text }
              end
            end
          },
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then return "" end -- not recording
              return "Recording @" .. reg
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
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = { fg = palette.peach },
          },
          -- {
          --   "encoding",
          --   cond = M.conditions.hide_in_width,
          -- },
          {
            function()
              local clients = {}
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              local icon = ''
              for _, client in pairs(buf_clients) do
                if client.name == "copilot" then
                  local status = require("copilot.api").status.data.status
                  if status == "Warning" then
                    icon = " "
                  else
                    icon = " "
                  end
                else
                  table.insert(clients, client.name)
                end
              end
              if #clients > 0 then
                return string.format(" LSP:[%s] " .. icon, table.concat(clients, " • "))
              else
                return icon
              end
            end,
            color = { fg = palette.mauve },
            cond = M.conditions.hide_lsp,
          },
          "filetype"
        },
      }
    }
    return opts
  end
}
