return {
  'akinsho/toggleterm.nvim',
  version = false,
  event = "VeryLazy",
  config = function()
    local map = vim.keymap.set
    map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",
      { desc = "Toggle float terminal", noremap = true, silent = true })
    map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",
      { desc = "Toggle vertical terminal", noremap = true, silent = true })
    map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>",
      { desc = "Toggle horizontal terminal", noremap = true, silent = true })
    map("n", "<leader>ts", "<CMD>TermSelect<CR>", { desc = "Select terminal", noremap = true, silent = true })
    map("n", "<leader>tn", "<CMD>TermNew<CR>", { desc = "New terminal", noremap = true, silent = true })

    -- move cursor on terminal mode
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<C-esc>', [[<C-\><C-n>]], opts)
      -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<cmd>wincmd h<cr>]], opts)
      vim.keymap.set('t', '<C-j>', [[<cmd>wincmd j<cr>]], opts)
      vim.keymap.set('t', '<C-k>', [[<cmd>wincmd k<cr>]], opts)
      -- vim.keymap.set('t', '<C-l>', [[<cmd>wincmd l<cr>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    local palette = require("catppuccin.palettes").get_palette "macchiato"
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "vertical" then
          return vim.o.columns * 0.3
        elseif term.direction == "horizontal" then
          return vim.o.lines * 0.25
        end
      end,
      open_mapping = [[<c-,>]],
      shade_terminals = false,
      float_opts = {
        -- see :h nvim_open_win for details on borders however
        border = 'rounded'
      },
      highlights = {
        FloatBorder = {
          guifg = palette.blue,
        },
      },
    })
  end
}
