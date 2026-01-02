# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- [1Password CLI](https://developer.1password.com/docs/cli/get-started) (for secrets)

## Setup

### Prerequisites

This dotfiles repository is designed to work with [ghq](https://github.com/x-motemen/ghq) for repository management.

### Install

```bash
# Using ghq (recommended)
ghq get massy22/dotfiles
chezmoi init --source $(ghq root)/github.com/massy22/dotfiles --apply

# Without ghq
chezmoi init --apply massy22/dotfiles
```

### First-time setup

During `chezmoi init`, you will be prompted for:

- `pcType`: Enter `personal` or `work`
- `1Password account ID`: Run `op account list` to find your account ID

### 1Password Configuration

Create a Secure Note in 1Password named `Dotfiles Config` with the following fields:

**命名規則:**
- `*_personal` - 個人アカウント用
- `*_work` / `*_work_*` - 仕事用（work PC でのみ使用）

| Field | Description | Required |
|-------|-------------|----------|
| `github_pat_personal` | GitHub PAT for personal account | Always |
| `git_email_work` | Work email address | Work only |
| `github_pat_work` | GitHub PAT for work | Work only |
| `github_work_org` | Work GitHub organization (e.g., `myorg`) | Work only |
| `github_enterprise_host` | GitHub Enterprise host | Work only |
| `claude_work_env` | Claude Code env settings (JSON) | Work only |
| `claude_work_plugin` | Claude work plugin name | Work only |
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

- Shell: `.zshrc`, `.zshrc.custom`, `.zshrc.alias`, `.zshrc.os` (OS-specific), `.zshrc.local`
- Git: `.gitconfig`, `.gitconfig-personal`, `.gitconfig.local`, `.gitignore`
- Vim: `.vimrc`, `.ideavimrc`
- Ruby: `.gemrc`, `.irbrc`, `.pryrc`
- Tmux: `.tmux.conf`
- Terminal: `.dir_colors`
- Config: `.config/nvim`, `.config/peco`, `.config/powerline`
- Claude: `.claude/settings.json`
- Gemini: `.gemini/settings.json`
- Scripts: `.local/bin/*`

## Notes

- `.vim` and `.zsh` directories are not managed by chezmoi (legacy symlinks)
- Secrets are stored in 1Password and injected via templates
- Work-specific settings are only applied when `pcType` is `work`
