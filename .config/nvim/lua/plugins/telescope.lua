return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      local diagnostics = function()
        builtin.diagnostics({ bufnr = 0 })
      end
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live [G]rep' })
      vim.keymap.set('n', '<leader>fd', diagnostics, { desc = 'Telescope search [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr.', builtin.oldfiles, { desc = 'Telescope search Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope search [K]eymaps' })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fc', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Telescope search [C]onfig files' })

      require('telescope').setup({
        defaults = {
          prompt_prefix = "   ",
          -- selection_caret = " ",
          -- entry_prefix = " ",
          sorting_strategy = "ascending",
          results_title = false,
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          -- layout_strategy = "horizontal",
          -- layout_config = {
          --   horizontal = {
          --     preview_width = 0.6,
          --     prompt_position = "top",
          --   },
          -- },
          -- vimgrep_arguments = {
          --   'rg',
          --   '--no-heading',
          --   '--with-filename',
          --   '--line-number',
          --   '--column',
          -- }
          mappings = {
            i = {
              ["J"] = function(bufnr)
                require("telescope.actions").preview_scrolling_down(bufnr)
              end,
              ["K"] = function(bufnr)
                require("telescope.actions").preview_scrolling_up(bufnr)
              end,
              ["<C-j>"] = function(bufnr)
                require("telescope.actions").move_selection_next(bufnr)
              end,
              ["<C-k>"] = function(bufnr)
                require("telescope.actions").move_selection_previous(bufnr)
              end,
              ["<Esc>"] = function (bufnr)
                require("telescope.actions").close(bufnr)
              end
            },
            n = {
              ["q"] = function (bufnr)
                require("telescope.actions").close(bufnr)
              end
            }
          },
        },
        pickers = {
          find_files = {
            -- find_command = { 'fd', '-t', 'f', '--hidden', '--exclude', '.git', '--exclude', 'node_modules', '--exclude', '.venv' },
            file_ignore_patterns = { 'node_modules', '^.git', '.venv', '%.png', '%.jpg', 'target' },
            hidden = true,
            no_ignore = true,
          },
          live_grep = {
            file_ignore_patterns = { 'node_modules', '^.git', '.venv', '%.png', '%.jpg', 'target' },
            additional_args = { "--hidden" }
          }
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim"
  }
}
