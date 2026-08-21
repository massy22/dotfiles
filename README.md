# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Prerequisites

- [Homebrew](https://brew.sh/)
- [chezmoi](https://www.chezmoi.io/install/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started) (for secrets)
- [ghq](https://github.com/x-motemen/ghq) (optional, recommended for repository management)
- GitHub authentication via [GitHub CLI](https://cli.github.com/manual/gh_auth_login), SSH, or a credential helper

## Setup

### Install

Review the diff before applying files to avoid overwriting existing dotfiles unexpectedly.

Using ghq:

```bash
ghq get massy22/dotfiles
chezmoi init --source "$(ghq root)/github.com/massy22/dotfiles"
chezmoi diff
chezmoi apply
```

Without ghq:

```bash
chezmoi init massy22/dotfiles
chezmoi diff
chezmoi apply
```

### First-time setup

During `chezmoi init`, you will be prompted for:

- `pcType`: Enter `personal` or `work`
- `1Password account_uuid`: Run `op account list --format=json` and use the
  `account_uuid` field, not the `user_uuid` that the plain `op account list`
  table shows. Every `onepasswordRead` passes it explicitly, so `op` never has
  to choose between accounts and `OP_ACCOUNT` does not have to be in the
  environment.

Without a TTY, answer the prompt on the command line instead. The flag matches
on the prompt text, not on the data key:

```bash
chezmoi init --promptString '1Password account_uuid=<account_uuid>'
```

### GitHub SSH account routing

This repository routes GitHub access through SSH host aliases so personal and work repositories use separate keys without embedding account names or PATs in git URLs.

Create or place SSH keys with generic filenames:

```bash
~/.ssh/github_personal
~/.ssh/github_work
```

Register each public key with the matching GitHub account, then apply the managed SSH config:

```bash
chezmoi diff
chezmoi apply
```

Verify each alias:

```bash
ssh -T github.com-personal
ssh -T github.com-work
```

If an existing repository should be pinned explicitly, update its remote to the alias form:

```bash
git remote set-url origin git@github.com-personal:massy22/dotfiles.git
git remote set-url origin git@github.com-work:ORG/REPO.git
```

`ORG/REPO` should be replaced locally. Do not write work account names into this repository.

### Homebrew packages

Homebrew packages are managed as `~/.Brewfile` via chezmoi. After applying dotfiles, check what would be installed before running the bundle:

```bash
chezmoi diff
chezmoi apply
brew bundle check --global
brew bundle --global
```

Edit `dot_Brewfile.tmpl` in this repository when adding or removing packages. Do not edit the generated `~/.Brewfile` directly.

### 1Password Configuration

Create a Secure Note in 1Password named `Dotfiles Config` with the following fields:

**命名規則:** `<domain>_work_<attr>`（ドメインを先頭、work マーカーを中間に置く）

| Field | Description | Required |
|-------|-------------|----------|
| `git_work_name` | Work Git user name | Work only |
| `git_work_email` | Work email address | Work only |
| `github_work_org` | Work GitHub organization (e.g., `myorg`) | Work only |
| `github_work_account` | Work GitHub account name | Work only |
| `github_work_enterprise_host` | GitHub Enterprise host | Work only |
| `claude_work_env` | Claude Code env settings (JSON) | Work only |
| `claude_work_bq_table` | BigQuery table backing the statusline cost display | Work only |
| `otel_work_bearer_token` | OTEL bearer token for Claude Code headers | Work only |
| `gemini_work_telemetry` | Gemini telemetry settings (JSON) | Work only |
| `tools_work_path` | PATH to work tools | Work only |
| `migration_work_dir` | Migration directory | Work only |
| `spanner_work_migration_dir` | Spanner migration directory | Work only |
| `vertex_work_project_id` | Vertex AI / GCP project ID | Work only |

The list above is the complete set referenced by the templates; verify with
`grep -rhoE 'op://[^"]+' --include='*.tmpl' .`

## Update

```bash
chezmoi update
```

## Files managed

- Shell: `.zshrc`, `.zshrc.local`, `.zsh/` (options, path, prompt, alias, os-darwin, etc.)
- Git: `.gitconfig`, `.gitconfig-personal`, `.gitconfig.local`, `.gitignore`, `.gitattributes`
- Homebrew: `.Brewfile`
- Vim: `.vimrc`, `.config/nvim` (`shared.rc.vim` + options + keymap), `.ideavimrc`
- Tmux: `.tmux.conf`
- Config: `.config/nvim`, `.config/peco`, `.config/ghostty`
- SSH: `.ssh/config`
- Claude: `.claude/settings.json`, `.claude/CLAUDE.md`, `.claude/statusline.sh`, `.claude/tmux-claude-state.sh`, `.claude/otel-headers-helper.sh`
- Scripts: `.local/bin/tmux-claude-next`
- Gemini: `.gemini/settings.json`

## Claude Code + tmux

Claude Code sessions report their state to the tmux status line, so a
window that is waiting for you is visible from any other window.

- `.claude/settings.json` registers hooks that call
  `.claude/tmux-claude-state.sh`, which stores the state in the tmux
  window option `@cc`.
- `.tmux.conf` renders `@cc` next to the window index:
  orange `●` waiting for approval or input, green `●` response finished,
  blue `◌` still working.
- `prefix + C-j` jumps to the waiting window (falling back to a finished
  one) via `.local/bin/tmux-claude-next`.

After `chezmoi apply`, reload tmux with `prefix + r` and restart Claude
Code so the new hooks are picked up.

## Notes

- `.zsh/` holds shell modules (`options.zsh`, `path.zsh`, `prompt.zsh`, `alias.zsh`, `os-darwin.zsh`, `peco.zsh`, `magic-abbrev.zsh`, etc.); `.zshrc` sources them; editor config is `.vimrc` and `.config/nvim`
- Secrets are stored in 1Password and injected via templates
- Work-specific settings are only applied when `pcType` is `work`
- GitHub PATs are not embedded in git remote URLs. GitHub repository access is routed through SSH host aliases.
