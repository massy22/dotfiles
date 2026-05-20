# macOS Trash helper (rmf)
function rmf() {
  for file in "$@"; do
    __rm_single_file "$file"
  done
}

function __rm_single_file() {
  if ! [[ -d ~/.Trash/ ]]; then
    command /bin/mkdir ~/.Trash
  fi

  if ! [[ $# -eq 1 ]]; then
    echo "__rm_single_file: 1 argument required but $# passed."
    return 1
  fi

  if [[ -e "$1" ]]; then
    local basename="${1:t}" name="$basename" count=0
    while [[ -e "$HOME/.Trash/$name" ]]; do
      count=$((count + 1))
      name="${basename}.${count}"
    done
    command /bin/mv -- "$1" "$HOME/.Trash/$name"
  else
    echo "No such file or directory: $1"
  fi
}
