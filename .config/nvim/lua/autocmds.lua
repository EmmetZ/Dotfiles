local function augroup(name)
  return vim.api.nvim_create_augroup("vim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
--   callback = function()
--     vim.cmd(":silent !kitty @ set-font-size 14")
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   callback = function ()
--     vim.cmd(":silent !kitty @ set-font-size 13")
--   end
-- })
