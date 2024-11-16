return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- event = "VeryLazy",
  ft = 'markdown',
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    enabled = false,
    bullet = {
      -- Padding to add to the left of bullet point
      left_pad = 2,
    },
  },
}
