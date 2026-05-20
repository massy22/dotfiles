" Shared settings for Vim and Neovim (sourced from ~/.vimrc and options.rc.vim)

"-------------------------------------------------------------------------------
" Basics
"-------------------------------------------------------------------------------
set autoread
set backspace=indent,eol,start
set hidden
set noundofile
set scrolloff=5
set textwidth=0
set vb t_vb=
set whichwrap=b,s,h,l,<,>,[,]
set clipboard=unnamed

let $VIMTMP = expand('~/.cache/vim')
if !isdirectory(expand($VIMTMP))
  call mkdir(expand($VIMTMP), 'p')
endif
set directory=$VIMTMP
set backupdir=$VIMTMP

"-------------------------------------------------------------------------------
" Indent
"-------------------------------------------------------------------------------
set autoindent
set smartindent
set cindent
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=0

filetype plugin indent on
syntax enable

augroup vimrc_indent
  autocmd!
  autocmd FileType apache,c,cpp,cs,diff,eruby,java,perl,php,python,sh,sql,vb,wsh,xhtml,xml,zsh setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
  autocmd FileType css,html,javascript,jsx,vim,yaml,scala setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
  autocmd FileType go setlocal noexpandtab list tabstop=2 shiftwidth=2
augroup END

"-------------------------------------------------------------------------------
" Display
"-------------------------------------------------------------------------------
set number
set showmatch
set list
set listchars=tab:>.,trail:_,extends:>,precedes:<
set display=uhex
set cursorline
set lazyredraw

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

augroup vimrc_cursorline
  autocmd!
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter,BufRead * setlocal cursorline
augroup END

"-------------------------------------------------------------------------------
" Search
"-------------------------------------------------------------------------------
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

"-------------------------------------------------------------------------------
" Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac
set encoding=utf-8

"-------------------------------------------------------------------------------
" Editing
"-------------------------------------------------------------------------------
set virtualedit+=block

augroup vimrc_editing_shared
  autocmd!
  autocmd BufWritePre * %s/\s\+$//ge
augroup END

"-------------------------------------------------------------------------------
" Quickfix
"-------------------------------------------------------------------------------
function! ToggleQfWindow()
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&buftype') ==# 'quickfix'
      cclose
      return
    endif
  endfor
  botright cwindow
endfunction

augroup vimrc_quickfix_shared
  autocmd!
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwindow
  autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwindow
augroup END

"-------------------------------------------------------------------------------
" Tags
"-------------------------------------------------------------------------------
set tags=tags;
set notagbsearch

nnoremap t <Nop>
nnoremap tt <C-]>
nnoremap tj :<C-u>tag<CR>
nnoremap tk :<C-u>pop<CR>
nnoremap tl :<C-u>tags<CR>
