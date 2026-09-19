return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function(opts)
    require("nvim-autopairs").setup(opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    local cond = require("nvim-autopairs.conds")
    npairs.add_rules({
      Rule("$", "$", { "tex", "latex", "typst", "markdown" })
        :with_pair(cond.not_after_regex("[%w%.]"))
        :replace_map_cr(function()
          return "<C-g>u<CR><C-c>O<Tab>"
        end),
    })
  end,
}
