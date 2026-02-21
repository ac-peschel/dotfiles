vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number relativenumber")
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { silent = true })
vim.opt.guicursor = ""
vim.cmd("colorscheme default")
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection primary",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection primary -o",
  },
  cache_enabled = 0,
}
vim.keymap.set("n", "<C-v>", '"+p', {})
vim.keymap.set("v", "<C-c>", '"+y', {})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", 
    "clone", 
    "--filter=blob:none", 
    "https://github.com/folke/lazy.nvim.git", 
    "--branch=stable", 
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  -- Colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme kanagawa-dragon")
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    end
  },

  -- Oil
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ["<CR>"] = "actions.select",
          ["-"] = "actions.parent",
          ["q"] = "actions.close",
        },
      })
      vim.keymap.set("n", "<leader>e", "<Cmd>Oil<CR>", {})
    end
  },
})
