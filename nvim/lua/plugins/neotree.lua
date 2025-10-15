  return { 
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.cmd("Neotree filesystem reveal left")
      vim.keymap.set("n", "<C-b>", "<Cmd>Neotree filesystem reveal<CR>", {})
    end
  }
