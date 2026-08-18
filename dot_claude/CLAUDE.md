# Personal conventions

- Commit messages: Conventional Commits in English, with a scope. Use the
  body to explain *why* when the diff does not make it obvious.
- Dotfiles are managed with chezmoi. Never edit a generated file such as
  `~/.zshrc`, `~/.tmux.conf`, or `~/.claude/settings.json` directly; edit
  the chezmoi source and apply from there.
- Environment: zsh, nvim, tmux, Ghostty on macOS.
