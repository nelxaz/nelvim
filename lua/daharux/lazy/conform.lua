return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    local formatters = opts.formatters_by_ft

    formatters.javascript = { "oxlint" }
    formatters.javascriptreact = { "oxlint" }
    formatters.typescript = { "oxlint" }
    formatters.typescriptreact = { "oxlint" }
    formatters.json = { "oxlint" }
    formatters.jsonc = { "oxlint" }
    formatters.css = { "oxlint" }
    formatters.scss = { "oxlint" }
    formatters.html = { "oxlint" }
    formatters.rust = { "rustfmt" }

    opts.format_on_save = opts.format_on_save or { timeout_ms = 500, lsp_fallback = true }

    return opts
  end,
}
