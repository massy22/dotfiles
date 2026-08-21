# CLAUDE.md

## What this repository is

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/). Files
here are *sources*, not the files in use: `~/.zshrc`, `~/.tmux.conf`,
`~/.claude/settings.json` and the rest are generated from this directory
by `chezmoi apply`.

## Editing rules

- Edit the source in this repository, never the generated file in `$HOME`:
  `dot_zshrc` → `~/.zshrc`, `dot_zsh/alias.zsh` → `~/.zsh/alias.zsh`,
  `dot_claude/modify_settings.json.tmpl` → `~/.claude/settings.json`.
- `*.tmpl` files are Go templates rendered by chezmoi.
  `dot_claude/modify_settings.json.tmpl` is a `modify_` script: it receives
  the current target file on stdin and merges into it, so it has to stay
  idempotent (feeding its own output back must produce the same bytes).
  Claude Code writes to that file too — `/model`, `/config`, and the auto
  mode `environment` block — so keys this repository does not manage must
  pass through untouched.
- Secrets come from 1Password through `onepasswordRead`, and every call
  passes `.onepasswordAccount` as its second argument. With more than one
  account configured, `op signin` without `--account` fails, and chezmoi has
  nowhere to keep that account for you: its own `onepassword:` config section
  parses into a struct of `command`/`mode`/`prompt`, so an `account` key there
  is dropped silently and cannot be read back. Hence `data.onepasswordAccount`
  in `.chezmoi.yaml.tmpl`, handed over by hand at all 17 call sites. chezmoi
  renders with `missingkey=error`, so a config that defines `pcType` has to
  define this key too — which is why the synthetic configs in the Makefile
  set it to the empty string. Keep that prompt's text free of `=`:
  `chezmoi init --promptString` matches on the prompt text rather than the
  key, and splits each pair on the first `=`, so a prompt containing one
  cannot be answered anywhere without a TTY.
- This repository is public: never commit a secret, a work organisation or
  account name, an internal hostname, a real email address, or an absolute
  path containing a user name.
- Work-only settings are gated on `pcType == "work"`, either in the template
  or through a conditional entry in `.chezmoiignore`.
- Do not reintroduce `TERM` overrides. `options.zsh` used to rewrite any
  `xterm*` TERM to `xterm-color`, an 8-colour terminfo, and the `tmux` alias
  forced `screen-256color`, which hid the real terminal from tmux so its
  `xterm*` `terminal-features` patterns could never match. The terminal's own
  TERM is correct; tmux sets `tmux-256color` for what runs inside it.
- peco styles use palette indices (`on_8`), not hex, so they follow whatever
  terminal theme is set. Keep highlighted rows dark-background/light-text:
  peco draws matched substrings in cyan, which disappears on a light band.

## Claude Code integration

A session reports its state to the tmux status line, so a window waiting for
input is visible from any other window. Three pieces have to agree:

- `dot_claude/modify_settings.json.tmpl` registers hooks on
  `UserPromptSubmit`, `Notification`, `Stop`, and `SessionEnd`.
- `dot_claude/executable_tmux-claude-state.sh` writes `busy`, `wait`, or
  `done` into the tmux *window* option `@cc` for `$TMUX_PANE`, or clears it.
  It no-ops outside tmux.
- `dot_tmux.conf` renders `@cc` in `window-status-format`, and
  `dot_local/bin/executable_tmux-claude-next` (`prefix + C-j`) jumps to the
  first window whose `@cc` is `wait`, falling back to `done`.

Two things bite when editing these:

- Hooks use the shell form (`"command": "~/.claude/… busy"`), not the exec
  form with `args`, because exec form does not tilde-expand the path.
- A `#[…]` style tag inside a `#{?…}` tmux conditional must not contain a
  comma. tmux reads it as the argument separator and the branch silently
  disappears, so use single-attribute tags such as `#[fg=colour214]`.

`allow-passthrough`, `extended-keys`, and the `extkeys` terminal-feature come
from Claude Code's own terminal documentation; without them notifications,
the progress bar, and Shift+Enter do not survive tmux.

## Status line

`dot_claude/executable_statusline.sh.tmpl` renders the session line. The JSON
Claude Code feeds it on stdin carries the model, context window, cost and
`rate_limits`, but *not* the plan or the provider, so both are derived:

- Provider comes from the `CLAUDE_CODE_USE_*` env vars, checked in the same
  order as Claude Code's own resolver (bedrock, foundry, anthropicAws,
  anthropicGoogleCloud, mantle, vertex, else first party) and with the same
  truthiness test, where only `1`/`true`/`yes`/`on` count. A plain `-n` test
  would read `CLAUDE_CODE_USE_VERTEX=0` as Vertex.
- Plan comes from `~/.claude.json` `.oauthAccount`: `organizationType`
  (`claude_pro`/`claude_max`/`claude_team`/`claude_enterprise`) and
  `userRateLimitTier` (`default_claude_max_5x`/`_20x`/`_zero`), which is the
  part that differs between two seats on the same plan. That file belongs to
  Claude Code, so treat every key as optional and keep the fallbacks.
- `.rate_limits` proves a session is spending subscription quota, but it is
  absent until the first response arrives. It can confirm, never decide alone:
  keying off it is what once labelled subscription sessions as Vertex.
- The model-scoped weekly window — Fable's, which Claude Code labels
  `Fable 5 limit` internally — is not on stdin either. `rate_limits` is
  assembled from `five_hour` and `seven_day` alone, and every other claim is
  dropped: `seven_day_opus`, `seven_day_sonnet` and the overage-included one
  that Fable consumes. It comes from `~/.claude.json`
  `cachedUsageUtilization` instead, which `/usage` writes and nothing else
  refreshes, hence the age beside the bar and no bar until `/usage` has been
  opened once. Look for `utilization.limits[]` with `kind: weekly_scoped` and
  a `scope.model.display_name`; the `percent` there is already 0-100, while
  the utilisation figures on stdin are fractions.

The BigQuery lines are Vertex-only, and gated on the session actually running
on Vertex. The export receives rows for Vertex traffic and nothing else, so a
subscription seat gets an empty result however the query is written, which is
what made a permanent `本日 $0.00` look like a broken query. Do not lift that
gate to "fix" a missing line; check the provider first. The table also drops
rows after a few months, so history older than that is gone rather than
mismatched.

Within the section the rows split on `is_claude_ai`, a two-value column, so
the labels can be precise but the split cannot get finer. A failed `bq` no
longer drops the lines silently — it prints `⛅ BQ 取得不可 (…)` with the
reason, and data that outlived a failed refresh carries its age.
`gcloud 再認証が必要` means the token expired: run `gcloud auth login`.

## Verifying a change

```bash
make check     # JSON/TOML syntax, zsh -n, shellcheck, chezmoi render
chezmoi diff   # what would change in $HOME
```

For `dot_tmux.conf`, a throwaway server reports config errors that
`start-server` swallows and exits 0 on:

```bash
tmux -L check -f /dev/null new-session -d
tmux -L check source-file dot_tmux.conf   # non-zero on a bad line
tmux -L check kill-server
```

Do not run `chezmoi apply` unless asked; it rewrites files in `$HOME`.
When `pcType` is `work` it reads from 1Password, so the desktop app has to be
running and unlocked with CLI integration enabled. The account itself comes
from `data.onepasswordAccount`, so `OP_ACCOUNT` does not need to be set.

After applying, reload with `prefix + r` for tmux and `src` (aliased to
`exec zsh`) for the shell; restart Claude Code for settings or hook changes.
A changed `TERM` needs more than a reload: the client's TERM is fixed at
attach time and a pane's at creation time, so detach and re-attach from a
shell that has re-read `alias.zsh`, then open a new window.

## Things that do not clean up after themselves

- `tmux source-file` adds and overwrites bindings but never removes one that
  was deleted from the config. After dropping a `bind`, run
  `tmux unbind <key>` in the running server too. To find leftovers, diff
  `tmux list-keys` against a throwaway server sourcing the same file.
- `chezmoi apply` does not delete a target whose source entry was removed.
  Delete the generated file in `$HOME` by hand.
- Every `make check` recipe containing a loop must start with
  `set -euo pipefail`. Without it the recipe's exit status is the last
  iteration's, so a failure in the middle passes silently — which is how a
  broken `settings.json` render once reached `main`.

## Tried and removed

Built, used, and taken out. Do not re-propose without new information:

- `ccw`, a shell function that picked a repository with ghq + peco and opened
  a tmux window running `claude`. The window's command was `claude`, so
  exiting it destroyed the window and its scrollback, unlike a window made
  with `prefix + c`.
- `prefix + g` and `prefix + G` popups for `tig status` and a shell. They
  duplicated what switching windows already gives.

## Commits

Conventional Commits in English, with a scope naming the area (`tmux`,
`claude`, `zsh`, `git`, `statusline`, `chezmoi`, `peco`, ...). Use the body to
explain *why* whenever the reason is not obvious from the diff.
