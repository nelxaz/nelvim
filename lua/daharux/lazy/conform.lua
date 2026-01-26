return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    local formatters = opts.formatters_by_ft

    formatters.javascript = { "prettier" }
    formatters.javascriptreact = { "prettier" }
    formatters.typescript = { "prettier" }
    formatters.typescriptreact = { "prettier" }
    formatters.json = { "prettier" }
    formatters.jsonc = { "prettier" }
    formatters.css = { "prettier" }
    formatters.scss = { "prettier" }
    formatters.html = { "prettier" }

    opts.format_on_save = opts.format_on_save or { timeout_ms = 500, lsp_fallback = true }

    return opts
  end,
}
