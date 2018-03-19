" =======================
" --- System Settings ---
" =======================

runtime! archlinux.vim          " Load system defaults
"let skip_defaults_vim=1        " Don't load defaults if ~/.vimrc is missing
set nocompatible                " Don't behave like Vi
filetype off                    " Disable filetype detection, required by Vundle

"set nobackup                       " Disable backups
set backupdir=~/.vim/backup         " Set backup location
set rtp+=~/.vim/bundle/Vundle.vim   " Set Vundle runtime path

call vundle#begin()             " <plugins>
Plugin 'VundleVim/Vundle.vim'   " Vundle
Plugin 'itchyny/lightline.vim'  " Lightline
Plugin 'joshdick/onedark.vim'   " One (dark) colour theme
call vundle#end()               " </plugins>

" =======================
" --- Format Settings ---
" =======================

set tabstop=4               " Visual spaces per tab
set softtabstop=4           " Spaces in tab when editing
set shiftwidth=4            " Autoindent spaces
set expandtab               " Convert tab to spaces

filetype plugin indent on   " Determine indentation rules by filetype
set encoding=utf8           " Use UTF-8 internally

" ==========================
" --- Interface Settings ---
" ==========================

syntax on           " Enable syntax highlight
set ruler           " Show line and cursor position
set number          " Enable line numbers
set showmatch       " Highlight code blocks
set hlsearch        " Highlight search results
set incsearch       " Highlight results while typing
set ignorecase      " Case insensitive search
set smartcase       " Except when explicitely using capitals
set wildmenu        " Command autocompletion 
set showcmd         " Show commands in status bar
"set spell          " Enable spell checking
"setlocal spell spelllang=en_gb " Set spell check language
"set cursorline     " Highlight current line
set scrolloff=2     " Start scrolling a few lines from the edge
set showtabline=2   " Always show tab bar
set laststatus=2    " Always show status bar
set noshowmode      " Hide default mode text
set mouse=a         " Enable mouse support

" =====================
" --- Colour Scheme ---
" =====================

let g:lightline = {
	\ 'colorscheme': 'one',
	\ }
