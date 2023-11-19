scriptencoding utf-8

""""""""""""""""""""""""""
" dein install
""""""""""""""""""""""""""

" cache directory
let $CACHE = expand('$HOME/.cache')

" make cache directory if not existed
if !isdirectory($CACHE)
	call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
	let s:dein_dir = fnamemodify('dein.vim', ':p')
	if !isdirectory(s:dein_dir)
		let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
		if !isdirectory(s:dein_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
		endif
	endif
	execute 'set runtimepath^=' .. substitute(
		\ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif


set nocompatible

if !exists('g:syntax_on')
	syntax on
	let g:syntax_on = 1
endif

filetype plugin on
filetype indent on

set number
set wildmenu
set esckeys
set ttyfast
set title
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set backspace=indent,eol,start
set cursorline
set ruler
set showmode
set showcmd

set hlsearch
set ignorecase
set incsearch
set laststatus=2
