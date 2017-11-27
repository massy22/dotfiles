"-------------------------------------------------------------------------------
" Basics
"-------------------------------------------------------------------------------

"let g:mapleader = ","         " set <Leader>
let g:mapleader = "\<Space>"  " set <Leader>


" enter command-mode by hit semicolon ;
noremap ; :

" swap comment-line histroy completion key
cnoremap <C-p> <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n> <Down>
cnoremap <Down>  <C-n>

"-------------------------------------------------------------------------------
" Tags
"-------------------------------------------------------------------------------

" key mappings for tags and searches
nnoremap t  <Nop>
" jump to current tag
nnoremap tt  <C-]>
" next tag
nnoremap tj  :<C-u>tag<CR>
" prev tag
nnoremap tk  :<C-u>pop<CR>
" tag list
nnoremap tl  :<C-u>tags<CR>

"-------------------------------------------------------------------------------
" Searching
"-------------------------------------------------------------------------------

" remove serch highlight by <ESC><ESC>
nmap <silent><ESC><ESC> :nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>

" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>

"-------------------------------------------------------------------------------
" Moving
"-------------------------------------------------------------------------------

" moving by display lines. logical line move is mappedd to <C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

" in insert mode moving key maps
inoremap  <C-e> <END>
inoremap  <C-a> <HOME>
" hjkl with ctrl
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" move to next/prev buffer by two space/bs pressing
nmap <Space><Space> :bn<CR>
nmap <BS><BS> :bp<CR>

" jump to last edited line
nnoremap gb '[
nnoremap gp ']

" jump to paired bracket
nnoremap ( %
nnoremap ) %

"-------------------------------------------------------------------------------
" Editing
"-------------------------------------------------------------------------------

" yank the word which is under cursor
nnoremap vy vawy

" visual mode block move
set virtualedit+=block

" select to end on line in visula mode
vnoremap v $h

" in insert mode,  jj fires esc
inoremap jj <Esc>

" in insert-mode, paste the clipboard
imap <C-v><C-V>  <ESC>pa

" yank to end on line
nmap y9 y$
nmap yd y$
" yank to head of line
nmap y0 y^
nmap yk y^

" remove from cursor to head of line
nnoremap <silent> <C-d> d0
inoremap <silent> <C-k> <Esc>lc^

" (insert mode) remove from cursor to end of line
inoremap <silent> <C-d> <Esc>lc$

" (insert mode) yank from cursor to head/end of line
inoremap <silent> <C-y>e <Esc>ly0<Insert>
inoremap <silent> <C-y>0 <Esc>ly$<Insert>

"-------------------------------------------------------------------------------
" Window
"-------------------------------------------------------------------------------

" http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca


" disable nomral mapped s
nnoremap s <Nop>

" move cursor to other window
" by CTRL-hjkl
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
" with s
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sw <C-w>w

" change window size (requires submode.vim)
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=

"call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
"call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
"call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
"call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
"call submode#map('bufmove', 'n', '', '>', '<C-w>>')
"call submode#map('bufmove', 'n', '', '<', '<C-w><')
"call submode#map('bufmove', 'n', '', '+', '<C-w>+')
"call submode#map('bufmove', 'n', '', '-', '<C-w>-')

" close window buffer
nnoremap sq :<C-u>q<CR>
" abandon window buffer
nnoremap sQ :<C-u>bd<CR>




"-------------------------------------------------------------------------------
" Quickfix
"-------------------------------------------------------------------------------

" in quickfix window, close by q/ESC
autocmd FileType qf nnoremap <buffer> q :ccl<CR>
autocmd FileType qf nnoremap <buffer> <ESC> :ccl<CR>

" toggle quickfix window by cw
function! s:toggle_qf_window()
  for bufnr in range(1,  winnr('$'))
    if getwinvar(bufnr,  '&buftype') ==# 'quickfix'
      execute 'ccl'
      return
    endif
  endfor
  execute 'botright cw'
endfunction
nnoremap <silent> cw :call <SID>toggle_qf_window()<CR>

