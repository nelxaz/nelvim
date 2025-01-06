return {
	"mhartington/formatter.nvim",
	config = function()
		require('formatter').setup({
			logging = false,
			filetype = {
				javascript = {
					-- prettierd
					function()
						return {
							exe = "prettierd",
							args = { vim.api.nvim_buf_get_name(0) },
							stdin = true
						}
					end
				},
				typescriptreact = {
					-- prettierd
					function()
						return {
							exe = "prettierd",
							args = { vim.api.nvim_buf_get_name(0) },
							stdin = true
						}
					end
				},
				-- other formatters ...
			}
		})
		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd
		augroup("__formatter__", { clear = true })
		autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
		})
	end
}
