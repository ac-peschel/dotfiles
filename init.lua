vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")
vim.cmd("set number relativenumber")
vim.g.mapleader = " "
vim.keymap.set("v", "<leader>y", '"+y', {})
vim.keymap.set("n", "<leader>p", '"+p', {})
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", {silent=true})
vim.o.wrap = false

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
   {
      "savq/melange-nvim",
      priority = 100,
      lazy = false,
      config = function()
         vim.cmd.colorscheme("melange")
      end
   },
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
         require("nvim-treesitter.configs").setup({
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
         })
      end
   },
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
   {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
         local action = require("telescope.actions")
         local select_default = function(prompt_bufnr)
            return actions.select_default(prompt_bufnr, "default")
         end
         require("telescope").setup({
            extensions= {
               ["ui-select"] = { require("telescope.themes").get_dropdown {} }
            },
            defaults = {
               mappings = {
                  i = { ["<CR>"] = select_default },
                  n = { ["<CR>"] = select_defaukt },
               }
            }
         })
         require("telescope").load_extension("ui-select")
      end
   },
   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
         require("nvim-autopairs").setup({
            check_ts = true,
            disable_filetypes = { "TelescopePrompt", "vim" },
         })
      end
   },
   {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v3.x",
      dependencies = {
         { "neovim/nvim-lspconfig" },
         { "williamboman/mason.nvim" },
         { "williamboman/mason-lspconfig.nvim" },
      },
      config = function()
         local lsp = require("lsp-zero")
         local lspc = require("lspconfig")
         local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>fs", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>ve", vim.lsp.buf.open_float, opts)
            vim.keymap.set("n", "<leader>dn", vim.lsp.buf.goto_next, opts)
            vim.keymap.set("n", "<leader>dp", vim.lsp.buf.goto_prev, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
         end
         require("mason").setup()
         require("mason-lspconfig").setup({
            handlers = {
               function(server_name)
                  lspc.rust_analyzer.setup({
                     on_attach = on_attach,
                     capabilities = lsp.get_capabilities(),
                  })
               end
            }
         })
      end
   },
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         { "nvim-tree/nvim-web-devicons" },
         { "MunifTanjim/nui.nvim" },
      },
      config = function()
         vim.keymap.set("n", "<leader>e", "<Cmd>Neotree float toggle<CR>", {})
      end
   },
}, {})
