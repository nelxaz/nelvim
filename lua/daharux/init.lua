require("daharux.remap")
require("daharux.set")

-- Solo inicializa lazy.nvim si aún no fue configurado por otra capa
if not vim.g.lazy_did_setup then
  require("daharux.standalone")
end
