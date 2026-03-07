local M = {}

local function safe_require(module)
  local ok, loaded = pcall(require, module)
  if not ok then
    return nil
  end

  return loaded
end

function M.get()
  local cmp_lsp = safe_require("cmp_nvim_lsp")
  if not cmp_lsp then
    return vim.lsp.protocol.make_client_capabilities()
  end

  return cmp_lsp.default_capabilities()
end

return M
