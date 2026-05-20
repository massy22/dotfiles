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
- `1Password account ID`: Run `op account list` to find your account ID

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

**命名規則:**
- `*_personal` - 個人アカウント用
- `*_work` / `*_work_*` - 仕事用（work PC でのみ使用）

| Field | Description | Required |
|-------|-------------|----------|
| `git_name_work` | Work Git user name | Work only |
| `git_email_work` | Work email address | Work only |
| `github_work_org` | Work GitHub organization (e.g., `myorg`) | Work only |
| `github_enterprise_host` | GitHub Enterprise host | Work only |
| `claude_work_env` | Claude Code env settings (JSON) | Work only |
| `claude_work_plugin` | Claude work plugin name | Work only |
| `otel_bearer_token` | OTEL bearer token for Claude Code headers | Work only |
| `gemini_work_telemetry` | Gemini telemetry settings (JSON) | Work only |
| `work_tools_path` | PATH to work tools | Work only |
| `work_migration_dir` | Migration directory | Work only |
| `work_spanner_migration_dir` | Spanner migration directory | Work only |
| `vertex_work_project_id` | Vertex AI / GCP project ID | Work only |

## Update

```bash
chezmoi update
```

## Files managed

- Shell: `.zshrc`, `.zshrc.custom`, `.zshrc.alias`, `.zshrc.os_darwin`, `.zshrc.local`
- Git: `.gitconfig`, `.gitconfig-personal`, `.gitconfig.local`, `.gitignore`
- Homebrew: `.Brewfile`
- Vim: `.vimrc`, `.config/nvim`, `.ideavimrc`
- Tmux: `.tmux.conf`
- Terminal: `.dir_colors`
- Config: `.config/nvim`, `.config/peco`
- SSH: `.ssh/config`
- Claude: `.claude/settings.json`
- Gemini: `.gemini/settings.json`

## Notes

- `.zsh/` is managed by chezmoi; editor config is `.vimrc` and `.config/nvim`
- Secrets are stored in 1Password and injected via templates
- Work-specific settings are only applied when `pcType` is `work`
- GitHub PATs are not embedded in git remote URLs. GitHub repository access is routed through SSH host aliases.
