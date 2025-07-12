return {
	{
		"rust-lang/rust.vim",
		ft = "rust",
		config = function()
			vim.g.rustfmt_autosave = 1
			vim.g.rust_conceal = 0
		end
	}
}
