return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			-- Configure diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			local capabilities = require('blink.cmp').get_lsp_capabilities()

			vim.lsp.config('lua_ls', { capabilities = capabilities })
			vim.lsp.enable('lua_la')

			vim.lsp.enable('rust_analyzer')
			vim.lsp.config('rust_analyzer', {
				settings = {
					['rust-analyzer'] = {
						cargo = {
							allFeatures = true
						}
					},
				},
			})

			vim.lsp.enable("gopls")
			vim.lsp.config("gopls", {
				settings = {
					analyses = {
						unusedparams = true,
						staticcheck = true,
						gofumpt = true,
						goimports = true
					},
				},
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('my.lsp', {}),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

					-- Diagnostic keymaps
					local opts = { buffer = args.buf }
					vim.diagnostic.config({ jump = { float = true } })
					vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
					-- send diagnostics to buffer
					vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

					-- LSP keymaps
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

					-- Auto-format ("lint") on save.
					-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
					if not client:supports_method('textDocument/willSaveWaitUntil')
							and client:supports_method('textDocument/formatting') then
						vim.api.nvim_create_autocmd('BufWritePre', {
							group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
							end,
						})
					end
				end,
			})
		end,
	}
}
