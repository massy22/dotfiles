# EDITOR, PATH, and runtime tools (bun, etc.)
export EDITOR=nvim
# PATH は ~/.zsh/os-darwin.zsh で Homebrew / pyenv 等を設定
typeset -U path
path=(
  $path
  "$HOME/.local/bin"
  "$HOME/bin"
  "/sbin"
  "/usr/local/bin"
)
export PATH

# bun
export BUN_INSTALL="$HOME/.bun"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
[[ -d "$BUN_INSTALL/bin" ]] && path=("$BUN_INSTALL/bin" $path)
