#!/bin/bash
# Claude Code の hook から呼ばれ、セッションの状態を tmux のウィンドウ
# オプション @cc に書く。dot_tmux.conf の window-status-format がこれを読み、
# 「どのウィンドウが自分の入力を待っているか」をステータスラインに出す。
#
# usage: tmux-claude-state.sh busy|wait|done|clear
#
# hook の JSON は stdin から届くが、状態は引数で受けるので読まない。
set -u

# tmux の外、または pane を特定できない場合は何もしない
[ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ] || exit 0

case "${1:-clear}" in
clear)
  tmux set-option -uw -t "$TMUX_PANE" @cc 2>/dev/null
  ;;
busy | wait | done)
  tmux set-option -w -t "$TMUX_PANE" @cc "$1" 2>/dev/null
  ;;
esac

exit 0
