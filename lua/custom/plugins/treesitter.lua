local M = {}

M = {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
	build = ':TSUpdate',
	ensure_installed = {
		'lua',
		'vim',
		'vimdoc',
		'java',
		'javascript',
		'typescript',
		'markdown',
		'markdown_inline',
	},
}

return M
