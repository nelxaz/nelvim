return {
  "mrcjkb/rustaceanvim",
  version = "^8",
  lazy = false,
  dependencies = {
    { "neovim/nvim-lspconfig" },
  },
  init = function()
    local lsp_capabilities = require("daharux.lsp.capabilities").get()

    vim.g.rustaceanvim = {
      server = {
        capabilities = lsp_capabilities,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            check = {
              command = "clippy",
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
    }
  end,
}
