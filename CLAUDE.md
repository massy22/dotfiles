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
- Secrets come from 1Password through `onepasswordRead`. This repository is
  public: never commit a secret, a work organisation or account name, an
  internal hostname, a real email address, or an absolute path containing a
  user name.
- Work-only settings are gated on `pcType == "work"`.

## Verifying a change

```bash
make check     # JSON/TOML syntax, zsh -n, shellcheck, chezmoi render
chezmoi diff   # what would change in $HOME
```

For `dot_tmux.conf`, a throwaway server reports config errors that
`start-server` swallows:

```bash
tmux -L check -f /dev/null new-session -d
tmux -L check source-file dot_tmux.conf   # non-zero on a bad line
tmux -L check kill-server
```

Do not run `chezmoi apply` unless asked; it rewrites files in `$HOME`.
When `pcType` is `work` it also needs `OP_ACCOUNT` set, or `op signin`
first, because templates read from 1Password.

After applying, reload with `prefix + r` for tmux and `src` (aliased to
`exec zsh`) for the shell; restart Claude Code for settings or hook
changes.

## Commits

Conventional Commits in English, with a scope naming the area (`tmux`,
`claude`, `zsh`, `git`, `statusline`, `chezmoi`, ...). Use the body to
explain *why* whenever the reason is not obvious from the diff.
