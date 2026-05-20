
# ls
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

# process
# alias j="jobs -l"
alias 'ps?'='pgrep -l -f'
alias pk='pkill -f'

# du/df
alias du="du -h"
alias df="df -h"
alias duh="du -h ./ --max-depth=1"

# su
alias su="su -l"

# vim
alias v='nvim'
alias vi='nvim'
alias 'src'='exec zsh'
alias -g V="| nvim -"
alias -g EV="| xargs --verbose sh -c 'nvim \"\$@\" < /dev/tty'"

# less
alias less='less -r'

# grep
alias 'gr'='grep --color=auto -ERUIn'

alias -g TEE="2>&1 | tee"

# make
alias 'm'='make'

# tmux
alias tmux='TERM=screen-256color tmux'
alias tm='tmux'
alias tmn='tmux new-session -n zsh'
alias tma='tmux attach'
alias tml='tmux list-sessions'

alias p='ping -c 4'

# git
alias g='git'
alias gi='git'
alias gs='git status -s -b'
alias gst="git log --date=short --max-count=1 --pretty=format:'%Cgreen%h %cd %Cblue%cn%x09%Creset%s' | tail -1 && echo '' && git status -s -b"
alias gc='git commit'
alias gci='git commit -a'

# git completion for aliases
compdef g=git
compdef gi=git

# jq
alias -g JQ='jq -C "."'
alias -g LJQ='jq -C "." | less -R'

function lessjq() {
  cat $1 | jq -C "." | less -R
}

function catjq() {
  cat $1 | jq -C "."
}

alias java='nocorrect java'
alias cp='nocorrect cp -irp'

alias ssh='TERM=xterm ssh'
