-- CURSOR MOVEMENT
vim.keymap.set("n", "j", "jzz", { desc = "Move one down and vertically center" })
vim.keymap.set("n", "k", "kzz", { desc = "Move one up and vertically center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move halfway down and vertically center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move halfway up and vertically center" })
vim.keymap.set("n", "'a", "'azz", { desc = "Move to marker A and vertically center" })
vim.keymap.set("n", "'b", "'bzz", { desc = "Move to marker B and vertically center" })
vim.keymap.set("n", "'c", "'azz", { desc = "Move to marker C and vertically center" })
vim.keymap.set("n", "'d", "'bzz", { desc = "Move to marker D and vertically center" })
vim.keymap.set("n", "'e", "'azz", { desc = "Move to marker E and vertically center" })
vim.keymap.set("n", "'f", "'bzz", { desc = "Move to marker F and vertically center" })

-- EXIT WHILE INSERTING
vim.keymap.set("i", "<C-c>", "<esc>", { desc = "Exit insert mode" })

-- FILE EXPLORER (NETRW)
vim.keymap.set("n", "<leader>pv", ":Vex<CR>")

-- FZF (unused while using Telescope)
-- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#commands
-- vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>")

-- GREP/RIPGREP
vim.keymap.set("n", "<leader>rg", ":Rg<Space>")

-- QUICKFIX
vim.keymap.set("n", "<C-j>", ":cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-k>", ":cprev<CR>", { desc = "Quickfix prev" })

-- CLIPBOARD MAGIC (assumes set clipboard!=unnamed)
vim.keymap.set("n", "<leader>y", '"+y', { desc = "enables copying the result of complex motions to the OS clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "enables copying a thing in visual mode to OS clipboard" })
vim.keymap.set("n", "<leader>Y", 'gg"+yG', { desc = "copies the entire file" })

-- LINE MANIPULATION
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves selected code down one line" })
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves selected code up one line" })

-- Explanation for line manipulation keymaps:
-- '> is the beginning of a highlighted region
-- '< is the end of a highlighted region
-- :m is performing a move of the selected region to outside of the highlighted
-- press enter, then highlight my previous highlight (gv=gv)

-- AUTOCOMPLETION
vim.keymap.set("i", "<tab>", function()
    local pumvisible = vim.fn.pumvisible() == 1
    if pumvisible then
        return "<C-y>" -- Select first item and confirm
    else
        return "<Tab>" -- Insert literal tab otherwise
    end
end, { expr = true })
