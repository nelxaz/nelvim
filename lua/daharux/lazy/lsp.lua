local capabilities = require("daharux.lsp.capabilities")

local function safe_require(module)
  local ok, loaded = pcall(require, module)
  if not ok then
    return nil
  end

  return loaded
end

local function setup_lsp_keymaps()
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
      local opts = { buffer = event.buf }

      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
      vim.keymap.set({ "n", "x" }, "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
      vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    end,
  })
end

local function setup_diagnostics()
  vim.diagnostic.config({
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
end

local function setup_completion()
  local cmp = safe_require("cmp")
  if not cmp then
    return
  end

  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  cmp.setup({
    snippet = {
      expand = function(args)
        local luasnip = safe_require("luasnip")
        if luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<S-tab>"] = cmp.mapping.select_prev_item(cmp_select),
      ["<tab>"] = cmp.mapping.select_next_item(cmp_select),
      ["<enter>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
    }),
  })
end

local function setup_servers(capabilities)
  local servers = {
    tsserver = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "mjs",
      },
    },
  }

  local mason = safe_require("mason")
  local mason_lspconfig = safe_require("mason-lspconfig")
  if not mason or not mason_lspconfig then
    return
  end

  mason.setup({})

  mason_lspconfig.setup({
    handlers = {
      function(server_name)
        if server_name == "rust_analyzer" then
          return
        end

        local server_config = servers[server_name] or {}

        vim.lsp.config[server_name] = vim.tbl_deep_extend("force", server_config, {
          capabilities = capabilities,
        })
      end,
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "mason-org/mason.nvim" },
    { "mason-org/mason-lspconfig.nvim" },
  },
  config = function()
    vim.opt.signcolumn = "yes"

    local lsp_capabilities = capabilities.get()

    setup_lsp_keymaps()
    setup_servers(lsp_capabilities)
    setup_completion()
    setup_diagnostics()
  end,
}
