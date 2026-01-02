"------------------------------------
" denite-gtags
"------------------------------------

" Keymap
nmap <silent> [denite]tr :DeniteCursorWord -buffer-name=gtags_ref gtags_ref<CR>
nmap <silent> [denite]td :DeniteCursorWord -buffer-name=gtags_def gtags_def<CR>
