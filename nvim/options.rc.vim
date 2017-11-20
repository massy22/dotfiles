"-------------------------------------------------------------------------------
" Basics
"-------------------------------------------------------------------------------

set textwidth=0               " don't insert linebreak when insert a long line
set nobackup                  " disable auto backup
set autoread                  " reload the file if other process updates it
set noswapfile                " avoid creating a swapfile
set hidden                    " buffer becomes hidden when it is abandoned
set formatoptions=jlmB        " formatting behaivior. disable auto comment insertion etc. see fo-table
set vb t_vb=                  " disable beep
set whichwrap=b,s,h,l,<,>,[,] " Allow to the cursor to move over the next/prev line
set nomodeline                " disable modeline
set notitle                   " 'Thanks for Flying Vim'
set noundofile                " avoid creating a undo file
set clipboard=unnamed         " put the yanked string into unnamed buffer(as system clipboard)
set wildmode=list:full        " command-line completion, list all matches and complete first match

"-------------------------------------------------------------------------------
" Indentation
"-------------------------------------------------------------------------------

set smartindent  " smart autoindenting when starting a new line
set cindent      " enables automatic C program indenting
set tabstop=2 shiftwidth=2 softtabstop=0

"-------------------------------------------------------------------------------
" Apperance
"-------------------------------------------------------------------------------

set showmatch         " highlight bracket pairs
set number            " show line number
set list              " list mode. show tab as following charactor
set listchars=tab:>.,trail:_,extends:>,precedes:< " to use in 'list' mode
set display=uhex      " show unprintable charactor as hex string

" highlight FullWidth white space
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

"-------------------------------------------------------------------------------
" Cursor
"-------------------------------------------------------------------------------

set cursorline   " highlight current cursor line
set lazyredraw   " stop rendering duraing command executing

" highlight only the current window's cursor line
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

" cursor line highlight settings. (draw underline)
hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" change the current cursor line color when into insert mode
augroup vimrc_change_cursorline_color
  autocmd!
  autocmd InsertEnter * highlight CursorLine term=underline cterm=underline ctermbg=240 gui=underline guibg=#666666 | highlight CursorColumn ctermfg=231 ctermbg=31 gui=bold guifg=#ffffff guibg=#0087af
  autocmd InsertLeave * highlight CursorLine term=underline cterm=underline ctermbg=235 gui=underline guibg=#333333 | highlight CursorColumn term=reverse ctermbg=235 guibg=#333333
augroup END

"-------------------------------------------------------------------------------
" Searching
"-------------------------------------------------------------------------------

set ignorecase  " case insensitive search
set smartcase   " disable ignorecase if search word contains uppercase charactor

"-------------------------------------------------------------------------------
" Colors
"-------------------------------------------------------------------------------
set termguicolors " 256 color

" change selected completion item color
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

" Highlight the go 'error'
autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/

" Highlight the js colon at end of line
autocmd FileType javascript :highlight jsColonAtTail  cterm=underline ctermfg=lightblue guibg=darkgray
autocmd FileType javascript :match jsColonAtTail /:$/

" vimdiff coloring
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

"-------------------------------------------------------------------------------
" Editing
"-------------------------------------------------------------------------------

" replace tab with whitespace
set expandtab

" drop the whitespaces at end of line
autocmd BufWritePre * :%s/\s\+$//ge

"-------------------------------------------------------------------------------
" Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac
set encoding=utf-8
