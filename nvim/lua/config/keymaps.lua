-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Word-wise cursor movement with Option + Arrow keys
vim.keymap.set({ "n", "i", "v" }, "<M-Left>", "b", { desc = "Move cursor to previous word" })
vim.keymap.set({ "n", "i", "v" }, "<M-Right>", "w", { desc = "Move cursor to next word" })

-- Insert mode specific mappings to maintain insert mode
vim.keymap.set("i", "<M-Left>", "<C-o>b", { desc = "Move cursor to previous word in insert mode" })
vim.keymap.set("i", "<M-Right>", "<C-o>w", { desc = "Move cursor to next word in insert mode" })
