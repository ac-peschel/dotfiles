vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number relativenumber")
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.o.wrap = false
vim.keymap.set("n", "<C-v>", '"+p', {})
vim.keymap.set("v", "<C-c>", '"+y', {})
