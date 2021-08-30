"Настройка отступов
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set clipboard=unnamedplus
"set cursorline
set scrolloff=4

"set spell spelllang=ru_ru,en_us

map <F8> :setlocal spell! spelllang=ru,en_us<CR>

"Можно добавлять слова в словарь, используя zg или удалять, используя zug
set number
set foldcolumn=0
syntax on
set noerrorbells
set novisualbell
set mouse=a
set history=200
set wrap
set linebreak
set nocompatible
set ruler
set autoindent

"Настройка поиска
set ignorecase
set smartcase
set hlsearch
set incsearch "Показывать первое вхождение
set encoding=utf8
set ffs=unix,dos,mac
let g:indent_guides_enable_on_vim_startup = 1

"Копирование текста в буфер обмена.Ctrl+@
xnoremap <silent> <C-@> :w !wl-copy<CR><CR>

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

map <F9> :Goyo<CR>:PencilSoft<CR>

"Цветовая схема
if (has('termguicolors'))
  set termguicolors
endif

colorscheme material
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'
set background=dark
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }

"vim-plug. :PlugInstall
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tomtom/tcomment_vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mzlogin/vim-markdown-toc'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

call plug#end()
