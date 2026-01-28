return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    local formatters = opts.formatters_by_ft

    formatters.javascript = { "prettierd" }
    formatters.javascriptreact = { "prettierd" }
    formatters.typescript = { "prettierd" }
    formatters.typescriptreact = { "prettierd" }
    formatters.json = { "prettierd" }
    formatters.jsonc = { "prettierd" }
    formatters.css = { "prettierd" }
    formatters.scss = { "prettierd" }
    formatters.html = { "prettierd" }

    opts.format_on_save = opts.format_on_save or { timeout_ms = 500, lsp_fallback = true }

    return opts
  end,
}
