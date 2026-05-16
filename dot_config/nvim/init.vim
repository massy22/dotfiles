if executable('python3')
  let g:python3_host_prog = exepath('python3')
endif

" load dein.vim and plugins
source ~/.config/nvim/dein.rc.vim

" load option settings
source ~/.config/nvim/options.rc.vim

" load key mapings
source ~/.config/nvim/keymap.rc.vim
