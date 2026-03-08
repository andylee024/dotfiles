" A good writeup of the .vimrc is here:
" http://dougblack.io/words/a-good-vimrc.html
syntax on

" Tab Handling
set tabstop=4
set softtabstop=4
set expandtab

" Config : delete button wasn't working
set backspace=indent,eol,start

" Set color
colorscheme desert

" Show line numbers
set number

" Show command in bottom bar
set showcmd

" Horizontal line under current row (no background highlight)
set cursorline
hi CursorLine cterm=underline ctermbg=NONE ctermfg=NONE gui=underline guibg=NONE

" Load filetype specific indentation rules
" ~/.vim/indent/python.vim would load for *.py
" filetype indent on

" Visual autocomplete for command menu
set wildmenu

" Redraw only when necessary, speeds up macros
set lazyredraw

" Vundle (plugin manager) configs

" be iMproved, required
set nocompatible              

" required
filetype off

" PEP8
" set colorcolumn=79


" remaps
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

" Cursor shapes: blinking beam in insert, steady underline in normal/replace
let &t_SI = "\e[5 q"   " insert mode  — blinking beam
let &t_SR = "\e[4 q"   " replace mode — steady underline
let &t_EI = "\e[2 q"   " normal mode  — steady block

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" required
call vundle#end()            
" required
filetype plugin indent on

