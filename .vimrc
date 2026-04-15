inoremap jj <Esc>

set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
set ignorecase
set smartcase
set cursorline
set showmatch
set wildmenu

set noswapfile
set ruler
set wrap
set linebreak

set splitbelow
set splitright

colorscheme habamax
set t_ut=

set number

" カッコ補完
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap " ""<LEFT>

" プラグイン
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/glyph-palette.vim'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#app
augroup END

set runtimepath+=/home/shurto11/ssd/vimtube
