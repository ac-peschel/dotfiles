return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "DaikyXendo/nvim-material-icon",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set("n", "<C-b>", "<Cmd>Neotree filesystem reveal left<CR>", {})
    vim.cmd("Neotree filesystem reveal left")
  end
}
