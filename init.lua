-- Basic Settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")
vim.cmd("set number relativenumber")
vim.g.mapleader = " "

vim.keymap.set("v", "<leader>y", '"+y', {})
vim.keymap.set("n", "<leader>p", '"+p', {})

-- Ensure LazyNVim
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

local plugins = {
   { 
      "catppuccin/nvim",
      name = "catppuccin",
      priotiry = 1000,
      config = function()
         vim.cmd.colorscheme "catppuccin"
      end
   },
   {
      {
         "nvim-telescope/telescope.nvim",
         tag = "0.1.8",
         dependencies = {
            "nvim-lua/plenary.nvim",
         },
         config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
         end
      },
      {
         "nvim-telescope/telescope-ui-select.nvim",
         config = function()
             local telescope = require 'telescope'
             local actions = require 'telescope.actions'
             local is_windows = vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1
             local vimfnameescape = vim.fn.fnameescape
             local winfnameescape = function(path)
               local escaped_path = vimfnameescape(path)
               if is_windows then
                 local need_extra_esc = path:find('[%[%]`%$~]')
                 local esc = need_extra_esc and '\\\\' or '\\'
                 escaped_path = escaped_path:gsub('\\[%(%)%^&;]', esc .. '%1')
                 if need_extra_esc then
                   escaped_path = escaped_path:gsub("\\\\['` ]", '\\%1')
                 end
               end
               return escaped_path
             end

             local select_default = function(prompt_bufnr)
               vim.fn.fnameescape = winfnameescape
               local result = actions.select_default(prompt_bufnr, "default")
               vim.fn.fnameescape = vimfnameescape
               return result
             end
            require("telescope").setup({
               extensions = {
                  ["ui-select"] = { require("telescope.themes").get_dropdown {} }
               },
               defaults = {
                  mappings = {
                     i = {
                        ["<CR>"] = select_default,
                     },
                     n = {
                        ["<CR>"] = select_default,
                     },
                  },
               },
            })
            require("telescope").load_extension("ui-select")
         end
      }
   },
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
         "DaikyXendo/nvim-material-icon",
         "MunifTanjim/nui.nvim",
      },
      config = function()
         vim.keymap.set("n", "<C-b>", "<Cmd>Neotree float toggle<CR>")
      end,
      opts = {
         filesystem = {
            filtered_items = {
               show_hidden_count = false,
               hide_gitignored = true,
               hide_by_name = {
                  ".git",
               }
            }
         }
      }
   },
   {
      "nvim-lualine/lualine.nvim",
      config = function()
         require("lualine").setup({
            options = { theme = "dracula" }
         })
      end
   },
   {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v2.x",
      dependencies = {
         { "neovim/nvim-lspconfig" },
         {
            "williamboman/mason.nvim",
            build = function()
               pcall(vim.cmd, "MasonUpdate")
            end,
         },
         { "williamboman/mason-lspconfig.nvim" },
         { "hrsh7th/nvim-cmp" },
         { "hrsh7th/cmp-nvim-lsp" },
         { "L3MON4D3/LuaSnip" },
         { "rafamadriz/friendly-snippets" },
         { "hrsh7th/cmp-buffer" },
         { "hrsh7th/cmp-path" },
         { "hrsh7th/cmp-cmdline" },
         { "saadparwaiz1/cmp_luasnip" },
      },
      config = function()
         local lsp = require("lsp-zero")
         lsp.on_attach(function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, vim.tbl_deep_extend("force", opts, {desc="LSP Goto Reference"}))
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }))
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }))
            vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }))
            vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }))
            vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
            vim.keymap.set("n", "gf", function() vim.lsp.buf.format() end, vim.tbl_deep_extend("force", opts, { desc = "LSP Format" }))
         end)

         require("mason").setup({})
         require("mason-lspconfig").setup({
            ensure_installed = {
               "csharp_ls",
            },
         })

         require("lspconfig").csharp_ls.setup({})

         local cmp_action = require("lsp-zero").cmp_action()
         local cmp = require("cmp")
         local cmp_select = { behavior = cmp.SelectBehavior.Select }

         require("luasnip.loaders.from_vscode").lazy_load()

         cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } }
         })

         cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
               { name = "path" }
            }, {
               {
                  name = "cmdline",
                  option = { ignore_cmds = { "Man", "!" } }
               }
            })
         })

         cmp.setup({
            snippet = {
               expand = function(args)
                  require("luasnip").lsp_expand(args.body)
               end
            },
            sources = {
               { name = "nvim_lsp" },
               { name = "luasnip", keyword_length = 2 },
               { name = "buffer", keyword_length = 3 },
               { name = "path" }
            },
            mapping = cmp.mapping.preset.insert({
               ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
               ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
               ["<CR>"] = cmp.mapping.confirm({ select = true }),
               ["<C-Space>"] = cmp.mapping.complete(),
            })
         })
      end
   },
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = { "gdscript", "godot_resource", "gdshader", "lua", "vim", "vimdoc" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
         })
      end
   },
   { "preservim/nerdcommenter" },
}

require("lazy").setup(plugins, {})
