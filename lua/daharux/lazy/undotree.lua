local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
return {
	'mbbill/undotree',
	config = function()
		vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
	end
}
