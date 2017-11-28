"------------------------------------
" Syntastic
"------------------------------------

" show error sign
let g:syntastic_enable_signs = 1
" highligt
let g:syntastic_enable_highlighting = 1
" auto open location list window
let g:syntastic_auto_loc_list=1

let g:syntastic_aggregate_errors = 1


" ---- JavaScript

" https://github.com/scrooloose/syntastic/wiki/JavaScript:---jsxhint
" require: npm install -g eslint
let g:syntastic_javascript_checkers = ['eslint'] " eshint
let g:syntastic_typescript_checkers = ['tsc']    " typescript

" ---- Go

" set gopath
if $GOPATH != ''
  execute "set rtp+=".globpath($GOPATH, "src/github.com/golang/lint/misc/vim")

  let g:syntastic_go_checkers = ['go',  'golint',  'govet']
endif

" ---- Ruby
let g:syntastic_mode_map = { 'mode': 'passive',
            \ 'active_filetypes': ['ruby', 'go', 'js', 'jsx'] }
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
