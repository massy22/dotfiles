let s:python_host_prog = expand('~/.pyenv/versions/neovim2/bin/python')
if executable(s:python_host_prog)
  let g:python_host_prog = s:python_host_prog
endif

let s:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
if executable(s:python3_host_prog)
  let g:python3_host_prog = s:python3_host_prog
endif

" load dein.vim and plugins
source ~/.config/nvim/dein.rc.vim

" load option settings
source ~/.config/nvim/options.rc.vim

" load key mapings
source ~/.config/nvim/keymap.rc.vim
