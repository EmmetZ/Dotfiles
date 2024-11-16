return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    -- scope = { enabled = false },
    scope = { show_start = false, show_end = false },
    exclude = {
      filetypes = {
        "Trouble",
        "alpha",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "trouble",
      },
    },
  },
}
