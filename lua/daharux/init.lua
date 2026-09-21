require("daharux.remap")
require("daharux.set")
-- Temporary bridge for Neovim 0.11+ breaking changes
if not vim.F then
  vim.F = {
    if_nil = function(val, default)
      if val == nil then return default end
      return val
    end
  }
end

-- Solo inicializa lazy.nvim si aún no fue configurado por otra capa
if not vim.g.lazy_did_setup then
  require("daharux.standalone")
end
