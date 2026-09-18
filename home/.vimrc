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

"" 空の {} 内で Enter を押したら、間に空行を作る
"" （filetype の indentexpr に依存せず明示的に行を組み立てる）
"function! s:expand_brackets() abort
"  let l:lnum  = line('.')
"  let l:line  = getline(l:lnum)
"  let l:cidx  = col('.') - 1                      " } の位置（0-based）
"  let l:before = strpart(l:line, 0, l:cidx)       " '... {'
"  let l:after  = strpart(l:line, l:cidx)          " '} ...'
"  let l:base   = matchstr(l:line, '^\s*')         " 開き行のインデント
"  let l:mid    = l:base . repeat(' ', shiftwidth())
"  call setline(l:lnum, l:before)
"  call append(l:lnum, [l:mid, l:base . l:after])  " 中間行 / 閉じ行は base のまま
"  call cursor(l:lnum + 1, strlen(l:mid) + 1)
"endfunction
"
"inoremap <silent><expr> <CR>
"      \ (col('.') > 1 && getline('.')[col('.') - 2] ==# '{' && getline('.')[col('.') - 1] ==# '}')
"      \ ? "\<C-\>\<C-o>:call \<SID>expand_brackets()\<CR>"
"      \ : "\<CR>"

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

" 無名レジスタをc/d/yレジスタにコピー
function! UseEasyRegname()
    if v:event.regname ==# ''
        call setreg(v:event.operator, getreg())
    endif
endfunction

augroup UseEasyRegname
    autocmd!
    au TextYankPost * call UseEasyRegname()
augroup END

" touch-server vim-client
if !empty($TMUX)
let s:tsbin = expand('~/ssd/tools/touch-server/target/release/touch-server')
if executable(s:tsbin)
  if has('nvim')
    autocmd VimEnter * call jobstart([s:tsbin, 'vim-client'])
  else
    autocmd VimEnter * call job_start([s:tsbin, 'vim-client'])
  endif
endif
endif

" ターミナルビューワー

" 非アクティブペインのグレー化（tmuxのwindow-styleはvimに効かないため自前で行う）
" tmux側の 'bg=color236,fg=color248' に合わせて全ハイライトを平坦化する
if !has('gui_running') && exists('*hlget')
  " screen/tmux系TERMでもフォーカスレポートを有効化
  let &t_fe = "\<Esc>[?1004h"
  let &t_fd = "\<Esc>[?1004l"

  let s:dimmed = 0
  let s:saved_hl = []

  function! s:DimOn() abort
    if s:dimmed | return | endif
    " airlineなどが動的に生成したハイライトも含めて丸ごと退避する
    let s:saved_hl = hlget()
    let s:dimmed = 1
    for l:group in getcompletion('', 'highlight')
      silent! execute 'highlight' l:group 'ctermfg=248 ctermbg=236 cterm=NONE'
    endfor
    silent! highlight Normal ctermfg=248 ctermbg=236 cterm=NONE
    redraw
  endfunction

  function! s:DimOff() abort
    if !s:dimmed | return | endif
    let s:dimmed = 0
    " 一度全消ししてから退避分を戻す。こうしないと平坦化で付けた
    " ctermfg/ctermbg が残り、リンク（airline_tabsel等）が復元されない
    call hlset(map(getcompletion('', 'highlight'),
          \ {_, v -> {'name': v, 'cleared': v:true, 'force': v:true}}))
    call hlset(map(copy(s:saved_hl), {_, v -> extend(copy(v), {'force': v:true})}))
    let s:saved_hl = []
    redraw
  endfunction

  augroup DimInactivePane
    autocmd!
    autocmd FocusLost   * call s:DimOn()
    autocmd FocusGained * call s:DimOff()
  augroup END
endif
