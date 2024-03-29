
"   ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"   ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"   ██║   ██║██║██╔████╔██║██████╔╝██║
"   ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"    ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"     ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝

" ~/.vimrc

" ===============================
" ------- System Settings -------
" ===============================

set nocompatible                " Don't behave like Vi
filetype off                    " Disable filetype detection, required by Vundle

"set nobackup                       " Disable backups
set backupdir=~/.vim/backup         " Set backup location
set rtp+=~/.vim/bundle/Vundle.vim   " Set Vundle runtime path

call vundle#begin()                         " <plugins>
Plugin 'VundleVim/Vundle.vim'               " Vundle
Plugin 'vim-airline/vim-airline'            " Airline
Plugin 'vim-airline/vim-airline-themes'     " Airline Themes
Plugin 'chris-1101/vim-arclight'            " Arclight Theme
Plugin 'airblade/vim-gitgutter'             " GitGutter
Plugin 'tpope/vim-fugitive'                 " Fugitive
Plugin 'scrooloose/nerdtree'                " Nerd Tree
Plugin 'joshdick/onedark.vim'               " One Dark Colour Theme
Plugin 'dracula/vim'                        " Dracula Colour Theme
Plugin 'ntk148v/vim-horizon'                " Horizon Colour Theme
Plugin 'ryanoasis/vim-devicons'             " Vim DevIcons
call vundle#end()                           " </plugins>

" ===============================
" ------- Format Settings -------
" ===============================

set tabstop=4               " Visual spaces per tab
set softtabstop=4           " Spaces in tab when editing
set shiftwidth=4            " Autoindent spaces
set expandtab               " Convert tab to spaces

filetype plugin indent on   " Determine indentation rules by filetype
set encoding=utf8           " Use UTF-8 internally

" ==================================
" ------- Interface Settings -------
" ==================================

syntax on           " Enable syntax highlight
set ruler           " Show line and cursor position
set number relativenumber " Enable line numbers
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

" =============================
" ------- Customisation -------
" =============================

color horizon

" Airline
let g:airline_theme = 'arclight'
let g:airline_extensions = ['branch', 'tabline']
let g:airline_powerline_fonts = 1

" Symbols Array
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Powerline Symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''

" Status Line
call airline#parts#define_raw('file', '%f %m')
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
call airline#parts#define_raw('colnr', '%c')
call airline#parts#define_accent('colnr', 'bold')
let g:airline_section_x = airline#section#create_right(['%{&fileformat}', '%{&fileencoding?&fileencoding:&encoding}'])
let g:airline_section_y = airline#section#create_right(['tagbar', 'gutentags', 'filetype'])
let g:airline_section_z = airline#section#create(['« %p%%', '   ', 'linenr', ':', 'colnr', ' '])

" Custom Mode Text
"let g:airline_mode_map = {
"    \ '__' : '---',
"    \ 'n'  : 'NML',
"    \ 'i'  : 'INS',
"    \ 'R'  : 'RPL',
"    \ 'c'  : 'COM',
"    \ 'v'  : 'VIS',
"    \ 'V'  : 'V-L',
"    \ ''  : 'V-B',
"    \ 's'  : 'SEL',
"    \ 'S'  : 'S-L',
"    \ ''  : 'S-B',
"    \ 't'  : 'TML'
"\ }
