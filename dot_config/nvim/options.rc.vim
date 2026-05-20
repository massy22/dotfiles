" Neovim-specific options (shared settings are in shared.rc.vim)

source ~/.config/nvim/shared.rc.vim

set nomodeline
set notitle
set formatoptions=jlmB
set wildmode=list:full
set termguicolors

augroup vimrc_change_cursorline_color
  autocmd!
  autocmd InsertEnter * highlight CursorLine term=underline cterm=underline ctermbg=236 gui=underline guibg=#3d425b
  autocmd InsertLeave * highlight CursorLine term=underline cterm=underline ctermbg=235 gui=underline guibg=#1e2132
augroup END
