return {
		"ggandor/leap.nvim",
		dependencies= {
				"tpope/vim-repeat"
		},
		config = function() 
				vim.keymap.set({'n', 'x', 'o'}, 's',  '<Plug>(leap-forward)')
				vim.keymap.set({'n', 'x', 'o'}, 'S',  '<Plug>(leap-backward)')
				vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)')
		end
}
