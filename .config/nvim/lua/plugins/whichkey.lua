return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = 'helix',
    -- win = { col = 0.5 },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>g", group = "git" },
        { "<leader>f", group = "find" },
        { "<leader>c", group = "code" },
        { "<leader>r", group = "rename", icon = { icon = "󰑕", color = "orange" } },
        { "<leader>t", group = "terminal" },
        { "<leader>d", group = "diagnostic" },
        { "<leader>l", group = "LSP", icon = { icon = "" } },
        { "<leader>m", group = "Misc", icon = { icon = "󱍭", color = "yellow" } },
        { "<leader>o", group = "Todo", icon = { icon = "", color = "green" } },
        { "g", group = "goto" },
        { "[", group = "prev" },
        { "]", group = "next" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
      }
    }
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
