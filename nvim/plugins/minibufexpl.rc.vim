"------------------------------------
" MiniBufExplorer

"------------------------------------

"set minibfexp
let g:miniBufExplMapWindowNavVim=1 " move hjkl
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10
let g:miniBufExplCycleArround = 1

":Toggle MiniBufExplorer
command! Mt :MBEToggle
