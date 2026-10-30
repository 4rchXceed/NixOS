source /etc/nixos/configs/neovim/plug.vim

call plug#begin()

Plug 'nvzone/volt'
Plug 'gisketch/triforce.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'romgrk/barbar.nvim'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'axsaucedo/neovim-power-mode'
Plug 'airblade/vim-gitgutter'
Plug 'github/copilot.vim'
Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }

call plug#end()

set keymodel=startsel
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching
set ignorecase              " case insensitive
set mouse=v                 " middle-click paste with
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
set colorcolumn=

autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

source /etc/nixos/configs/neovim/init.lua
source /etc/nixos/configs/neovim/cmp.lua
source /etc/nixos/configs/neovim/lsp.lua
source /etc/nixos/configs/neovim/lualine.lua

let NERDTreeMinimalUI=1

let g:moonflyTransparent = v:true
colorscheme moonfly

GitGutterEnable
