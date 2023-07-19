" let g:gruvbox_material_background = 'hard'
" let g:gruvbox_material_better_performance = 1
set background=dark
" colorscheme everforest

set matchtime=3 " show matching parenthesis a bit faster.
set cmdheight=2
set nu rnu numberwidth=4
set mouse=a
set cursorline
set hidden
set lazyredraw
set ttyfast
set scrolloff=3


set expandtab
set shiftwidth=2
set softtabstop=2
set shiftround

" improve search
set ignorecase
set smartcase
set hlsearch

set matchpairs+=<:> " pairs for % command

" no backup files
set nobackup
set noswapfile

" smart autoindenting when starting a new line
set smartindent
nnoremap <silent> <leader>gg :LazyGit<CR>

" augroup cdpwd
"     autocmd!
"     autocmd VimEnter * cd $PWD
" augroup END
