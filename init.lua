vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")
vim.cmd("set number relativenumber")
vim.g.mapleader = " "
vim.keymap.set("v", "<leader>y", '"+y', {})
vim.keymap.set("n", "<leader>p", '"+p', {})
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {})
vim.o.wrap = false

-- Lazy
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
   -- Theming
   {
      "ellisonleao/gruvbox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
         require("gruvbox").setup({
            contrast = "hard",
            palette_overrides = {
               gray = "#928374",
               bright_yellow = "#d7a73b",
               neutral_yellow = "#d7a73b",
               bright_green = "#d7a73b",
               neutral_green = "#d7a73b",
               bright_orange = "#fe8019",
            },
            overrides = {
               Normal = { bg = "#282828", fg = "#ebdbb2" },
               Comment = { fg = "#928374", italic = true },
               String = { fg = "#d7a73b" },
               Keyword = { fg = "#fe8019", bold = true },
               Function = { fg = "#83a598", bold = true },
               Type = { fg = "#83a598" },
               Constant = { fg = "#d3869b" },
               Identifier = { fg = "#ebdbb2" },
               CmpItemAbbr = { fg = "#ebdbb2" },
               CmpItemAbbrMatch = { fg = "#d7a73b", bold = true },
               CmpItemAbbrMatchFuzzy = { fg = "#d7a73b", bold = true },
               CmpItemKind = { fg = "#83a598" },
               CmpItemMenu = { fg = "#d7a73b", italic = true },
               CmpItemKindFunction = { fg = "#83a598" },
               CmpItemKindVariable = { fg = "#d3869b" },
               CmpItemKindSnippet = { fg = "#fe8019" },
               CmpItemAbbrDeprecated = { fg = "#928374", strikethrough = true },
               CmpItemKindEvent = { fg = "#ebdbb2" },
               CmpItemKindOperator = { fg = "#ebdbb2" },
               CmpItemKindKeyword = { fg = "#ebdbb2" },
               CmpItemKindColor = { fg = "#ebdbb2" },
            }
         })
         vim.cmd("colorscheme gruvbox")
      end
   },

   -- Treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = {"BufReadPost", "BufNewFile"},
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = {
               "javascript",
               "typescript",
               "tsx",
               "html",
               "css",
               "json",
               "lua",
               "c",
               "cpp",
               "bash",
            },
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = false,
            },
            indent = {
               enable = true,
            }
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
            local actions = require("telescope.actions")
            local select_default = function(prompt_bufnr)
               return actions.select_default(prompt_bufnr, "default")
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
   
   -- Comment toggle
   {
      "preservim/nerdcommenter"
   },

   -- Autopairs
   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
         require("nvim-autopairs").setup({
            check_ts = true,
            disable_filetype = { "TelescopePrompt", "vim" },
         })
      end
   },

   -- Neotree
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch="v3.x",
      dependencies = {
         "nvim-tree/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
      },
      config = function()
         vim.keymap.set("n", "<leader>e", "<Cmd>Neotree float toggle<CR>", {})
      end
   },

   -- LSP
   {
      {
         "williamboman/mason.nvim",
         build = ":MasonUpdate",
         config = function()
            require("mason").setup()
         end
      },
      {
         "williamboman/mason-lspconfig.nvim",
         dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
         },
         config = function()
            require("mason-lspconfig").setup({
               ensure_installed = {
                  "ts_ls",
                  "eslint",
                  "jsonls",
                  "cssls",
                  "html"
               }
            })
         end
      },
      {
         "neovim/nvim-lspconfig",
         event = { "BufReadPre", "BufNewFile"},
         config = function()
            local lspconfig = require("lspconfig")
            local on_attach = function(client, bufnr)
               local ok, err = pcall(function()
                  vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Actions"})
                  vim.keymap.set("n", "K", vim.lsp.buf.signature_help, {buffer=bufnr, desc = "Signature"})
                  vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, {buffer=bufnr, desc="Hover"})
                  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {buffer=bufnr, desc="Rename"})
                  if client.server_capabilities.documentFormattingProvider then
                     vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                           vim.lsp.buf.format({async=true})
                        end
                     })
                  end
               end)
               if not ok then
                  vim.notify("LSP on_attach error:" .. err, vim.log.levels.ERROR)
               end
            end

            lspconfig.ts_ls.setup({
               on_attach = on_attach,
               flags = { debounce_text_changes = 150},
            })

            lspconfig.eslint.setup({
               on_attach = function(client, bufnr)
                  on_attach(client, bufnr)
                  client.server_capabilities.documentFormattingProvider = true
               end
            })

            lspconfig.html.setup({ on_attach = on_attach })
            lspconfig.cssls.setup({ on_attach = on_attach })
            lspconfig.jsonls.setup({ on_attach = on_attach })
         end
      }
   },

   -- Snippets
   {
      {
         "L3MON4D3/LuaSnip",
         dependencies = {
            "rafamadriz/friendly-snippets"
         },
         config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
         end
      },
      {
         "hrsh7th/nvim-cmp",
         dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
         },
         config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
               snippet = {
                  expand = function(args)
                     luasnip.lsp_expand(args.body)
                  end
               },
               mapping = cmp.mapping.preset.insert({
                  ["<C-Space>"] = cmp.mapping.complete(),
                  ["<CR>"] = cmp.mapping.confirm({select = true}),
                  ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                           cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                           luasnip.expand_or_jump()
                        else
                           fallback()
                        end
                  end, {"i", "s"}),
                  ["<S-Tab>"] = cmp.mapping(function(fallback) 
                     if cmp.visible() then
                        cmp.select_prev_item()
                     elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                     else
                        fallback()
                     end
                  end, {"i", "s"})
               }),
               sources = {
                  {name="nvim_lsp"},
                  {name="luasnip"},
                  {name="buffer"},
                  {name="path"}
               }
            })
         end
      }
   }
}
require("lazy").setup(plugins, {})
