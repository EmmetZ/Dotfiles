return {
  "snacks.nvim",
  opts = {
    indent = {
      enabled = true,
      hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
      animate = {
        enabled = false,
      },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = false }, -- we set this in options.lua
    toggle = { map = LazyVim.safe_keymap_set },
    words = { enabled = true },
    lazygit = {
      enabled = true,
      configure = false,
    },
    picker = {
      enabled = true,
      layout = {
        cycle = false,
      },
      sources = {
        lsp_declarations = {
          focus = "list",
          layout = {
            preset = "ivy",
          },
        },
        lsp_definitions = {
          focus = "list",
          layout = {
            preset = "ivy",
          },
        },
        lsp_implementations = {
          focus = "list",
          layout = {
            preset = "ivy",
          },
        },
        lsp_references = {
          focus = "list",
          layout = {
            preset = "ivy",
          },
        },
        lsp_type_definitions = {
          focus = "list",
          layout = {
            preset = "ivy",
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["K"] = { "preview_scroll_up", mode = "n" },
            ["J"] = { "preview_scroll_down", mode = "n" },
            ["<A-l>"] = { "toggle_ignored", mode = { "n", "i" } },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>n", function()
      if Snacks.config.picker and Snacks.config.picker.enabled then
        Snacks.picker.notifications()
      else
        Snacks.notifier.show_history()
      end
    end, desc = "Notification History" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-p>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
  },
  config = function(_, opts)
    local palette = require("catppuccin.palettes").get_palette("macchiato")
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = palette.overlay1 })
    vim.api.nvim_set_hl(0, "SnacksIndent", { fg = palette.surface0 })
    vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = palette.peach, bold = true })
    require("snacks").setup(opts)
  end,
}
