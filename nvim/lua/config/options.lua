-- SOURCE VIMRC
-- SOURCE VIMRC
-- SOURCE VIMRC

-- vim.cmd([[
--     source ~/.vimrc
-- ]])

-- SOURCE VIMRC END
-- SOURCE VIMRC END
-- SOURCE VIMRC END

vim.opt.clipboard = "unnamed"
vim.opt.colorcolumn = "100"
vim.opt.autoindent = true -- Enable automatic indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.mouse = "" -- Disable the mouse
vim.opt.smartindent = true -- Automatically indent new lines
vim.opt.shiftwidth = 4 -- Number of spaces used for each indentation step
vim.opt.softtabstop = 4
vim.opt.tabstop = 4 -- number of spaces a tab counts for
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 250
-- Use terminal colors only (true = no, false = yes)
vim.opt.termguicolors = true
-- Explicitly use the theme of the terminal
-- vim.cmd.colorscheme("default")
-- Define colors for TODO comments (Diagnostic groups)
-- vim.cmd([[
--   highlight DiagnosticError ctermfg=0 ctermbg=1
--   highlight DiagnosticHint  ctermfg=0 ctermbg=2
--   highlight DiagnosticInfo  ctermfg=0 ctermbg=4
--   highlight DiagnosticWarn  ctermfg=0 ctermbg=3
--   highlight DiagnosticTest  ctermfg=0 ctermbg=5
--   highlight TodoBgTODO ctermfg=0 ctermbg=1
--   highlight TodoBgFIX  ctermfg=0 ctermbg=2
--   highlight TodoBgNOTE  ctermfg=0 ctermbg=4
--   highlight TodoBgWARN  ctermfg=0 ctermbg=3
--   highlight TodoBgTest  ctermfg=0 ctermbg=5
-- ]])
