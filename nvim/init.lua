-- cant be bothered to switch to the vim.lsp api
-- 'never break a running system' - Sun Tzu
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alt, ver, plug)
  if tostring(name):match("lspconfig") then
    return
  end
  return original_deprecate(name, alt, ver, plug)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blobl:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("lazy").setup("plugins")
