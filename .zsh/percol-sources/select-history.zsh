function percol-select-history() {
  local tac_cmd
  which gtac &> /dev/null && tac_cmd=gtac || tac_cmd=tac
  which gsed &> /dev/null && sed_cmd=gsed || sed_cmd=sed
  BUFFER=$($tac_cmd ~/.zsh_history | $sed_cmd 's/^: [0-9]*:[0-9]*;//' \
    | percol --match-method regex --query "$LBUFFER")
  CURSOR=$#BUFFER         # move cursor
  zle -R -c               # refresh
}
zle -N percol-select-history

bindkey '^r' percol-select-history
