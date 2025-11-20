" disable unsafe modelines
set modelines=0

" line numbers
set number
set relativenumber

" show cursor position
set ruler

" flash instead of beep
set visualbell

" utf-8 everything
set encoding=utf-8

" allow project-specific .vimrc
set exrc

" block cursor everywhere
set guicursor=

" don't keep old search highlights
set nohlsearch

" allow hidden buffers
set hidden

" no annoying bells
set noerrorbells

" tab/indent settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" no line wrap
set nowrap

" smarter case-sensitive search
set smartcase

" no swap/backup files
set noswapfile
set nobackup

" persistent undo
set undodir=~/.vim/undodir
set undofile

" live search
set incsearch

" truecolor support
set termguicolors

" keep context while scrolling
set scrolloff=8

" hide mode (statusline usually shows it)
set noshowmode

" better completion menu
set completeopt=menuone,noinsert,noselect

" always show sign column
set signcolumn=yes

" highlight column 120
set colorcolumn=120

" remap to jk to exit insert mode 
inoremap jk <esc>

" show the current mode
set showmode

" highlight matching brackets
set showmatch

" faster redrawing (good for big files)
set lazyredraw

" allow backspace over everything
set backspace=indent,eol,start

" command line completion with tab
set wildmenu
set wildmode=longest:full,full

" remember last edit position when reopening a file
autocmd bufreadpost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g'\"" |
      \ endif

" show matching parentheses/brackets instantly
set matchtime=1

" set color scheme
colorscheme slate
set background=dark
