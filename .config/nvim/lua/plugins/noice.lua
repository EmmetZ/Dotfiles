return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = {
      -- view = "cmdline",
      format = {
        Search_replace = { pattern = '^:%%s/', icon = '󰛔', lang = 'regex' },
        Search_replace_block = { pattern = "^:%'<,'>s/", icon = '󰛔', lang = 'regex' },
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = vim.o.lines * 0.2,
        },
        -- size = {
        --   width = math.min(60, math.floor(vim.o.columns * 0.6)),
        -- },
      },
      -- cmdline_popupmenu = {
      --   position = {
      --     row = vim.o.lines * 0.2 + 3,
      --   },
      --   size = {
      --     width = math.min(60, math.floor(vim.o.columns * 0.6)),
      --   },
      -- },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        opts = {
          size = {
            max_width = math.floor(vim.o.columns * 0.6),
            max_height = math.floor(vim.o.lines * 0.5)
          },
        }
      },
      documentation = {
        opts = {
          size = {
            max_width = math.floor(vim.o.columns * 0.6),
            max_height = math.floor(vim.o.lines * 0.5)
          },
        }
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      -- for copilot.lua
      {
        filter = {
          event = 'msg_show',
          any = {
            { find = 'Agent service not initialized' },
          },
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = true,
      -- command_palette = true,
      long_message_to_split = true,
      -- lsp_doc_border = true,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>n",  "",                                                                            desc = "+noice" },
    { "<S-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
    { "<leader>nl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
    { "<leader>nh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
    { "<leader>na", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
    { "<leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
    { "<leader>np", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
    { "<c-b>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
  },
  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled,
    -- but this is not ideal when Lazy is installing plugins,
    -- so clear the messages in this case.
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
