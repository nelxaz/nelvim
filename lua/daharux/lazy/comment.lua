return {
	"numToStr/Comment.nvim",
	config = function()
		require('Comment').setup({
				toggler = {
						line = "t;",
						block = "tl;"
				}
		})
	end,
}
