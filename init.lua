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
   -- Theme
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme gruvbox")

         vim.api.nvim_set_hl(0, "CmpItemAbbr",        { fg = "#ebdbb2" })         
         vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",   { fg = "#fabd2f", bold = true })
         vim.api.nvim_set_hl(0, "CmpItemKind",        { fg = "#83a598" })
         vim.api.nvim_set_hl(0, "CmpItemMenu",        { fg = "#b8bb26", italic = true })
         vim.api.nvim_set_hl(0, "CmpItemKindFunction",{ fg = "#b8bb26" })
         vim.api.nvim_set_hl(0, "CmpItemKindVariable",{ fg = "#d3869b" })
         vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#fe8019" })
         vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",        { fg = "#fabd2f", bold = true })
         vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",   { fg = "#fabd2f", bold = true })
         local neutral = "#ebdbb2"
         vim.api.nvim_set_hl(0, "CmpItemKindEvent",    { fg = neutral })
         vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = neutral })
         vim.api.nvim_set_hl(0, "CmpItemKindKeyword",  { fg = neutral })
         vim.api.nvim_set_hl(0, "CmpItemKindSnippet",  { fg = neutral })
         vim.api.nvim_set_hl(0, "CmpItemKindColor",    { fg = neutral })
         vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", {
           fg = "#928374", -- gruvbox gray
           strikethrough = true,
         })
		end
	},

   -- Telescope
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

   -- Comment toggling
   {
      "preservim/nerdcommenter",
   },
   
   -- LSP
   {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup()
      end
   },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup({ ensure_installed = { 
            "ts_ls",
            "html",
            "cssls",
            "jsonls",
            "tailwindcss",
            "pyright",
         }})
      end
   },
   {
      "neovim/nvim-lspconfig",
      config = function()
         local lspconfig = require("lspconfig")
         local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, desc = "Code Actions" }
            if client.supports_method("textDocument/codeAction") then
               vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
            end
            vim.keymap.set("n", "K", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
         
            if client.supports_method("textDocument/formatting") then
               vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                     vim.lsp.buf.format({ asnyc = true })
                  end
               })
            end
         end
         
         lspconfig.ts_ls.setup({
            on_attach = on_attach,
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
         })

         lspconfig.html.setup({
            on_attach = on_attach,
            filetypes = { "html" }
         })

         lspconfig.cssls.setup({
            on_attach = on_attach,
            filetypes = { "css", "scss", "less" }
         })

         lspconfig.jsonls.setup({
            on_attach = on_attach,
            filetypes = { "json", "jsonc" }
         })

         lspconfig.tailwindcss.setup({
            on_attach = on_attach,
            filetypes = {
               "html",
               "javascript",
               "javascriptreact",
               "typescript",
               "typescriptreact",
               "vue",
               "svelte",
               "php"
            }
         })

         lspconfig.pyright.setup({
            on_attach = on_attach,
            filetypes = { "pytho" },
            root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml"),
            settings = {
               python = {
                  analysis = {
                     typeCheckingMode = "strict",
                     autoSearchPaths = true,
                     useLibraryCodeForTypes = true,
                  }
               }
            }
         })
      end
   },

   -- Cmp & LuaSnip
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "L3MON4D3/LuaSnip",
         "saadparwaiz1/cmp_luasnip",
      },
      config = function()
         local cmp = require("cmp")
         cmp.setup({
            snippet = {
               expand = function(args)
                  require("luasnip").lsp_expand(args.body)
               end
            },
            mapping = cmp.mapping.preset.insert({
               ["<Tab>"] = cmp.mapping.select_next_item(),
               ["<S-Tab>"] = cmp.mapping.select_prev_item(),
               ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
               { name = "nvim_lsp" },
               { name = "luasnip" },
            },
         })
      end
   },

   -- Code Actions
   {
     "nvimtools/none-ls.nvim",
     config = function()
       local null_ls = require("null-ls")
       local u = require("null-ls.utils").make_conditional_utils()

       null_ls.setup({
         sources = {},
         on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Actions" })
            if client.supports_method("textDocument/formatting") then
               vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  callback = function()
                     vim.lsp.buf.format({ async = false })
                  end
               })
            end
         end
       })
     end,
   },

   -- Oil Explorer
   {
     "stevearc/oil.nvim",
     lazy = false,
     dependencies = { "nvim-tree/nvim-web-devicons" },
     config = function()
       require("oil").setup({
         default_file_explorer = false,
         view_options = {
           show_hidden = true,
         },
         float = {
           padding = 2,
           max_width = 80,
           max_height = 40,
           border = "rounded",
         },
       })

       vim.api.nvim_create_autocmd("User", {
         pattern = "OilEnter",
         callback = function()
           vim.b._previous_bufnr = vim.fn.bufnr("#")
         end,
       })

       vim.api.nvim_create_autocmd("BufWinLeave", {
         pattern = "*oil*",
         callback = function()
           local prev = vim.b._previous_bufnr
           if prev and vim.api.nvim_buf_is_valid(prev) then
             vim.defer_fn(function()
               vim.cmd("buffer " .. prev)
             end, 0)
           end
         end,
       })

       vim.keymap.set("n", "<leader>e", require("oil").toggle_float, { desc = "Oil (floating)" })
     end,
   },

   -- Treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "BufReadPost",
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "javascript", "typescript", "css", "html", "json" },
            highlight = { enable = true },
            autopairs = { enable = true },
            ident = { enable = true }
         })
      end
   },

   -- Autopairs
   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
         require("nvim-autopairs").setup({
            check_ts = true,
            disable_filetype = { "TalescopePrompt", "vim" },
         })
      end
   },
}
require("lazy").setup(plugins, {})
