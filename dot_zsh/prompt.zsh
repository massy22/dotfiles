# プロンプトと git ブランチ表示（~/.zshrc.custom から source）

case ${UID} in
0)
  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [[ -n "${REMOTEHOST}${SSH_CONNECTION}" ]] &&
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
  ;;
*)
  #
  # Color
  #
  RESET="%{${reset_color}%}"
  BLUE="%{${fg[blue]}%}"
  WHITE="%{${fg[white]}%}"
  POH="$"

  #
  # Prompt
  #
  PROMPT='%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}'
  RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${RESET}'

  #
  # Vi入力モードでPROMPTの色を変える
  # http://memo.officebrook.net/20090226.html
  #
  function zle-line-init zle-keymap-select {
    case $KEYMAP in
      vicmd)
        PROMPT="%{$fg_bold[cyan]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
        ;;
      main|viins)
        PROMPT="%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}${POH} ${RESET}"
        ;;
    esac
    zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select

  # Show git branch when you are in git repository
  # http://d.hatena.ne.jp/mollifier/20100906/p1

  # show status of git pushed to HEAD in prompt
  function _git_not_pushed() {
    local upstream ahead
    if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
      upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)" || {
        echo "|?"
        return 0
      }
      ahead="$(git rev-list --count "${upstream}..HEAD" 2>/dev/null)"
      [[ "${ahead:-0}" -gt 0 ]] && echo "|?"
    fi
    return 0
  }

  # git のブランチ名 *と作業状態* を zsh の右プロンプトに表示＋ status に応じて色もつけてみた
  # http://d.hatena.ne.jp/uasi/20091025/1256458798
  autoload -Uz VCS_INFO_get_data_git
  VCS_INFO_get_data_git 2>/dev/null

  function rprompt-git-current-branch {
    local name st color gitdir action pushed
    [[ "$PWD" =~ '/\.git(/.*)?$' ]] && return

    name="$(git rev-parse --abbrev-ref=loose HEAD 2>/dev/null)" || return

    gitdir="$(git rev-parse --git-dir 2>/dev/null)"
    action=$(VCS_INFO_git_getaction "$gitdir") && action="|$action"
    pushed="$(_git_not_pushed)"

    st="$(git status --porcelain=v1 2>/dev/null)"
    if [[ -z "$st" ]]; then
      color=%F{green}
    elif [[ "$st" == *\?\?* ]]; then
      color=%B%F{red}
    else
      color=%F{yellow}
    fi

    echo "[$color$name$action$pushed%f%b]"
  }

  RPROMPT='`rprompt-git-current-branch`${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)${WHITE}]${RESET}'
  ;;
esac
