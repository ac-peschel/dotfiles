--Basic Settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set relativenumber")
vim.g.mapleader = " "

-- Assert LazyNVim (Install if missing)
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

-- Specify Plugins
local plugins = {
    -- Theme
    { 
        "catppuccin/nvim", 
        name="catppuccin", 
        priority=1000,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end
    },

    -- Telescope
    { 
        "nvim-telescope/telescope.nvim",
        tag="0.1.8",
        dependencies={
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown {} }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    },

    -- Treesitter
    { 
        "nvim-treesitter/nvim-treesitter", 
        build=":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = {"lua", "javascript", "typescript", "css", "html"},
                highlight = { enable=true },
                indent = { enable=true },
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
            vim.keymap.set("n", "<C-b>", ":Neotree float toggle<CR>", {})
        end
    },

    -- Lualine
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "dracula"
                }
            })
        end
    },

    -- LSPConfig
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "html", "css_variables", "eslint" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.html.setup({})
            lspconfig.css_variables.setup({})
            lspconfig.eslint.setup({})
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, {})
        end
    }
}

-- Specify Options
local opts = {}

require("lazy").setup(plugins, opts)
