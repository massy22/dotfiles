
if &compatible
  set nocompatible
endif

filetype plugin indent on

" ensure cache dir
let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

let s:dein_dir = expand('$CACHE/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" git clone dein if not installed
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " load pluginsettings from toml file
  call dein#load_toml('~/.config/nvim/dein.toml',     {'lazy' : 0})
  call dein#load_toml('~/.config/nvim/deinlazy.toml', {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

autocmd VimEnter * call dein#call_hook('post_source')
