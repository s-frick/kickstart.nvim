vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print 'Installing lazy.nvim....'
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
  print 'Done.'
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {                            -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                  -- Required
      { 'hrsh7th/cmp-nvim-lsp' },              -- Required
      { 'L3MON4D3/LuaSnip' },                  -- Required
      {
        'jay-babu/mason-null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
          'williamboman/mason.nvim',
          'jose-elias-alvarez/null-ls.nvim',
        },
      },
    },
  },
  { 'mfussenegger/nvim-jdtls' },
  { 'rcarriga/nvim-dap-ui',   requires = { 'mfussenegger/nvim-dap' } },
  {
    'folke/neodev.nvim',
    opts = { library = { plugins = { 'nvim-dap-ui' }, types = true } },
  },
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup {}
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  }, -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',   opts = {} },
  { 'ckolkey/ts-node-action', dependencies = { 'nvim-treesitter' }, opts = {} },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = { char = '┊', show_trailing_blankline_indent = false },
  },                                      -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',     opts = {} }, -- {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  { 'echasnovski/mini.surround', version = '*' },
  { import = 'custom.plugins' },
  { import = 'kickstart.plugins' },
}

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true -- relative line numbers

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Map Esc to kk
map('i', 'kk', '<Esc>')

-- Clear search highlighting with <leader> and c
map('n', '<leader>hh', ':nohl<CR>')
-- harpoon
map('n', '<leader>hu', "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = '[H]arpoon [U]I-Menu' })
map('n', '<leader>h1', "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", { desc = '[H]arpoon [1] entry' })
map('n', '<leader>h2', "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", { desc = '[H]arpoon [2] entry' })
map('n', '<leader>h3', "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", { desc = '[H]arpoon [3] entry' })
map('n', '<leader>h4', "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>", { desc = '[H]arpoon [4] entry' })
map('n', '<leader>h5', "<Cmd>lua require('harpoon.ui').nav_file(5)<CR>", { desc = '[H]arpoon [5] entry' })
map('n', '<leader>ha', "<Cmd>lua require('harpoon.mark').add_file()<CR>", { desc = '[H]arpoon [A]dd File' })
map('n', '<leader>hj', "<Cmd>lua require('harpoon.ui').nav_next()<CR>", { desc = '[H]arpoon Next File' })
map('n', '<leader>hk', "<Cmd>lua require('harpoon.ui').nav_prev()<CR>", { desc = '[H]arpoon Previous File' })
map('n', '<A-j>', 'ddp', { desc = 'Line down' })
map('n', '<A-k>', 'ddkP', { desc = 'Line up' })

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = { mappings = { i = { ['<c-u>'] = false, ['<c-d>'] = false } } },
}

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- see `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- you can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local lsp = require('lsp-zero').preset {}

local on_attach = function(client, bufnr)
  lsp.default_keymaps { buffer = bufnr }
end
lsp.on_attach(on_attach)

lsp.skip_server_setup { 'jdtls', 'ocamllsp' }

lsp.format_mapping('gq', {
  format_opts = { async = false, timeout_ms = 10000 },
  servers = { ['null_ls'] = { 'javascript', 'typescript', 'lua', 'java' } },
})

local null_ls = require 'null-ls'

null_ls.setup {
  sources = {
    -- Here you can add tools not supported by mason.nvim
    -- make sure the source name is supported by null-ls
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    null_ls.builtins.code_actions.eslint_d, -- TODO: need keymapping
    -- :'<,'>lua vim.lsp.buf.range_code_action()
    -- :'<,'>Telescope lsp_range_code_actions
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.code_actions.ts_node_action,
    null_ls.builtins.completion.spell,
    null_ls.builtins.diagnostics.jshint,
    null_ls.builtins.diagnostics.jsonlint,
    null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.npm_groovy_lint,
    null_ls.builtins.diagnostics.tidy,
    null_ls.builtins.diagnostics.todo_comments,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.deno_fmt,
    null_ls.builtins.formatting.elm_format,
    null_ls.builtins.formatting.google_java_format,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.formatting.prettierd,
  },
}

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require('mason-null-ls').setup {
  ensure_installed = { 'google_java_format', 'java', 'typescript', 'jq', 'lua' },
  automatic_installation = true, -- You can still set this to `true`
  handlers = {
    -- Here you can add functions to register sources.
    -- See https://github.com/jay-babu/mason-null-ls.nvim#handlers-usage
    --
    -- If left empty, mason-null-ls will  use a "default handler"
    -- to register all sources
  },
}

local lspconfig = require 'lspconfig'
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
lspconfig.lua_ls.setup { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }

lspconfig.ocamllsp.setup {}
lspconfig.ocamlls.setup {}

lsp.setup()

local keymap = vim.keymap.set

-- LSP Workspace related stuff
keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { desc = '[L]SP: [W]orkspace [A]dd' })
keymap('n', '<leader>lwd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { desc = '[L]SP: [W]orkspace [R]emove' })
keymap('n', '<leader>w', '<cmd>:w<CR>', { desc = '[W]rite Buffer' })

-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>')

-- Code action
keymap({ 'n', 'v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>')

-- Rename all occurrences of the hovered word for the entire file
keymap('n', 'gr', '<cmd>Lspsaga rename<CR>')

-- Rename all occurrences of the hovered word for the selected files
keymap('n', 'gr', '<cmd>Lspsaga rename ++project<CR>')

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')

-- Go to definition
keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')

-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap('n', 'gT', '<cmd>Lspsaga peek_type_definition<CR>')

-- Go to type definition
keymap('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>')

-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap('n', '<leader>sl', '<cmd>Lspsaga show_line_diagnostics<CR>')

-- Show buffer diagnostics
keymap('n', '<leader>sb', '<cmd>Lspsaga show_buf_diagnostics<CR>')

-- Show workspace diagnostics
keymap('n', '<leader>sw', '<cmd>Lspsaga show_workspace_diagnostics<CR>')

-- Show cursor diagnostics
keymap('n', '<leader>sc', '<cmd>Lspsaga show_cursor_diagnostics<CR>')

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
keymap('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>')

-- Diagnostic jump with filters such as only jumping to an error
keymap('n', '[E', function()
  require('lspsaga.diagnostic'):goto_prev {
    severity = vim.diagnostic.severity.ERROR,
  }
end)
keymap('n', ']E', function()
  require('lspsaga.diagnostic'):goto_next {
    severity = vim.diagnostic.severity.ERROR,
  }
end)

-- Toggle outline
keymap('n', '<leader>o', '<cmd>Lspsaga outline<CR>')

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
keymap('n', 'K', '<cmd>Lspsaga hover_doc ++keep<CR>')

-- Call hierarchy
keymap('n', '<Leader>ci', '<cmd>Lspsaga incoming_calls<CR>', { desc = 'LSP: [c]alls [i]ncoming' })
keymap('n', '<Leader>co', '<cmd>Lspsaga outgoing_calls<CR>', { desc = 'LSP: [c]alls [o]ncoming' })

-- Floating terminal
keymap({ 'n', 't' }, '<A-d>', '<cmd>Lspsaga term_toggle<CR>')

vim.cmd [[colorscheme everforest]]
vim.cmd [[
  source ~/.config/nvim/options.vim
]]
