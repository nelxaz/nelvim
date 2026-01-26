return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft

    local has_lazyvim = pcall(require, "lazyvim.util")
    if has_lazyvim then
      return
    end

    local group = vim.api.nvim_create_augroup("daharux_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = group,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
