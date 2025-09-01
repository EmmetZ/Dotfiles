return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- Or `LspAttach`
  priority = 1000,    -- needs to be loaded in first
  config = function()
    require('tiny-inline-diagnostic').setup({
      transparent_bg = true,
      options = {
        multilines = {
          enabled = true,
          always_show = true,
        },
        format = function(diag)
          local msg = ""
          if diag.severity == vim.diagnostic.severity.ERROR or diag.severity == vim.diagnostic.severity.WARN then
            msg = string.format("%s / %s", diag.message, diag.source)
            if diag.code and diag.code ~= "undefined-field" then
              msg = string.format("%s[%s]", msg, diag.code)
            end
            return msg
          end
          return diag.message
        end
      },
    })
    vim.diagnostic.config({ virtual_text = false })
  end
}
