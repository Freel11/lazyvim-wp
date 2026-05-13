-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.scrolloff = 999

-- Write files in-place instead of delete-and-rename (atomic save).
-- Prevents file watchers (Vite, webpack, etc.) from losing the file mid-save.
vim.opt.backupcopy = "yes"
