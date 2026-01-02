# percol + git issue
function found_command { which $1 &> /dev/null }
function is_issued() {
  ISSUE_TYPE=$(git config issue.type 2>/dev/null)
  if [ "$ISSUE_TYPE" != "" ]; then
      return 0
  else
      return 1
  fi
}
function is_issueType_redmine {
  ISSUE_TYPE=$(git config issue.type 2>/dev/null)
  if [ "$ISSUE_TYPE" = "redmine" ]; then
      return 1
  else
      return 0
  fi
}
# git-issue listからチケットを選んでgit flowのfeatureブランチを作る
function percol_select_from_git_issue_list_to_git_flow_feature_start() {
  if $(is_issued) ; then
    echo "Loading..."
    TICKET=$(git-issue --no-color list | percol --match-method migemo | ssed -e 's/^#\([0-9]*\).*/\1/')
    BUFFER="git flow feature start id/$TICKET"
    CURSOR=$#BUFFER
    zle -R -c
  else
    echo "issue.typeが設定されてません"
    echo # 上記のechoが出ない
    zle reset-prompt
  fi
}
#git-issue listからチケットを選んで詳細情報の表示
function percol_select_from_git_issue() {
  if $(is_issued) ; then
    echo "Loading..."
    TICKET=$(git-issue --no-color --mine list | percol --match-method migemo | sed -e 's/^#\([0-9]*\).*/\1/')
    git-issue show $TICKET
  else
    echo "issue.typeが設定されてません"
    echo # 上記のechoが出ない
    zle reset-prompt
  fi
}
#git-issue listからチケットを選んでブラウザで開く
function percol_select_from_git_issue_to_open() {
  if $(is_issued) ; then
    echo "Loading..."
    is_issueType_redmine
    _ret=$?
    if [ $_ret -ne 0 ]; then
      TICKET=$(git-issue --query='status_id=*&limit=50&sort=updated_on:desc' --no-color  --oneline | percol --match-method migemo | ssed -e 's/^#\([0-9]*\).*/\1/')
      ISSUE_URL=$(git config issue.url)
      open ${ISSUE_URL}issues/${TICKET}
    else
      GITHUB_USER_PROJECT="$(git config remote.origin.url|sed -E 's!^([^/]*/){3}!!'|sed -E 's!^([^:]*:)!!'|sed 's!\.git$!!')"
      TICKET=$(git-issue list --sort=updated --no-color --oneline | percol --match-method migemo | ssed -e 's/^#\([0-9]*\).*/\1/')
      ISSUE_URL="https://github.com/${GITHUB_USER_PROJECT}/issues"
      open ${ISSUE_URL}/${TICKET}
    fi
    zle reset-prompt
  else
    echo "issue.typeが設定されてません"
    echo # 上記のechoが出ない
    zle reset-prompt
  fi
}
function gilist (){
  is_issueType_redmine
  _ret=$?
  if [ $_ret -ne 0 ]; then
    git issue list --query='status_id=closed&limit=30&sort=updated_on:desc' --oneline
  else
    git issue list --state=closed --oneline
  fi
}

zle -N percol-git-recent-branches
zle -N percol-git-recent-all-branches

zle -N percol_select_from_git_issue_list_to_git_flow_feature_start
bindkey '^b^f' percol_select_from_git_issue_list_to_git_flow_feature_start

zle -N percol_select_from_git_issue
bindkey '^b^i' percol_select_from_git_issue

zle -N percol_select_from_git_issue_to_open
bindkey '^b^o' percol_select_from_git_issue_to_open
