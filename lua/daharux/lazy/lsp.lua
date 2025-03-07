return {
		'neovim/nvim-lspconfig',
		dependencies = {
				{'hrsh7th/cmp-nvim-lsp'},
				{'hrsh7th/nvim-cmp'},
				{'williamboman/mason.nvim'},
				{'williamboman/mason-lspconfig.nvim'},
		},
		config = function () 
				local cmp = require('cmp')
				vim.opt.signcolumn = 'yes'

				-- Add cmp_nvim_lsp capabilities settings to lspconfig
				-- This should be executed before you configure any language server
				local lspconfig_defaults = require('lspconfig').util.default_config
				lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lspconfig_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
				)

				-- This is where you enable features that only work
				-- if there is a language server active in the file
				vim.api.nvim_create_autocmd('LspAttach', {
						desc = 'LSP actions',
						callback = function(event)
								local opts = {buffer = event.buf}

								vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
								vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
								vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
								vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
								vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
								vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
								vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
								vim.keymap.set({'n', 'x'}, '<leader>fmt', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
								vim.keymap.set('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
								vim.keymap.set('n', '<leader>vrr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
								vim.keymap.set('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
								vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
								vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
								vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
						end,
				})

				require('mason').setup({})
				require('mason-lspconfig').setup({
						handlers = {
								function(server_name)
										require('lspconfig')[server_name].setup({})
								end,
						},
				})
				local cmp_select = { behavior = cmp.SelectBehavior.Select }

				cmp.setup({
						snippet = {
								expand = function(args)
										require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
								end,
						},
						mapping = cmp.mapping.preset.insert({
								['<S-tab>'] = cmp.mapping.select_prev_item(cmp_select),
								['<tab>'] = cmp.mapping.select_next_item(cmp_select),
								['<enter>'] = cmp.mapping.confirm({ select = true }),
								["<C-Space>"] = cmp.mapping.complete(),
								
						}),
						sources = cmp.config.sources({
								{ name = 'nvim_lsp' },
								{ name = 'luasnip' }, -- For luasnip users.
						}, {
								{ name = 'buffer' },
						})
				})

				vim.diagnostic.config({
						-- update_in_insert = true,
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

}
