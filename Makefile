SHELL := /bin/bash
PYTHON ?= python3

JSON_FILES := $(shell git ls-files '*.json' ':!:*.tmpl')
TOML_FILES := $(shell git ls-files '*.toml')
ZSH_FILES := dot_zshrc dot_zsh/options.zsh dot_zsh/path.zsh dot_zsh/trash.zsh dot_zsh/prompt.zsh dot_zsh/magic-abbrev.zsh dot_zsh/alias.zsh dot_zsh/os-darwin.zsh dot_zsh/peco.zsh
CHEZMOI_TARGETS := .zshrc .gitconfig .gitconfig.local .zshrc.local .Brewfile .ssh/config .claude/settings.json .gemini/settings.json
SHELL_FILES := dot_claude/executable_tmux-claude-state.sh dot_local/bin/executable_tmux-claude-next
SHELL_TARGETS := .claude/statusline.sh

.PHONY: check check-json check-toml check-zsh check-shell check-tmux check-chezmoi check-brewfile

check: check-json check-toml check-zsh check-shell check-tmux check-chezmoi check-brewfile

check-json:
	@set -euo pipefail; \
	if [ -z "$(JSON_FILES)" ]; then \
		echo "No JSON files to check"; \
		exit 0; \
	fi; \
	for file in $(JSON_FILES); do \
		[ -f "$$file" ] || continue; \
		echo "json $$file"; \
		$(PYTHON) -m json.tool "$$file" >/dev/null; \
	done

check-toml:
	@$(PYTHON) -c 'import pathlib, subprocess, tomllib; files = [pathlib.Path(f) for f in subprocess.check_output(["git", "ls-files", "*.toml"], text=True).splitlines()]; files = [f for f in files if f.is_file()]; [tomllib.load(open(f, "rb")) for f in files]; print("toml checked: {}".format(len(files)))'

check-zsh:
	@set -euo pipefail; \
	if ! command -v zsh >/dev/null 2>&1; then \
		echo "zsh not found; skipping zsh syntax check"; \
		exit 0; \
	fi; \
	for file in $(ZSH_FILES); do \
		echo "zsh -n $$file"; \
		zsh -n "$$file"; \
	done

check-shell:
	@set -euo pipefail; \
	if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "shellcheck not found; skipping shell lint"; \
		exit 0; \
	fi; \
	for file in $(SHELL_FILES); do \
		echo "shellcheck $$file"; \
		shellcheck "$$file"; \
	done; \
	if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "chezmoi not found; skipping rendered script lint"; \
		exit 0; \
	fi; \
	config_file="$$(mktemp "$${TMPDIR:-/tmp}/chezmoi.XXXXXX.yaml")"; \
	rendered="$$(mktemp "$${TMPDIR:-/tmp}/rendered.XXXXXX.sh")"; \
	trap 'rm -f "$$config_file" "$$rendered"' EXIT; \
	printf 'data:\n  pcType: personal\n' > "$$config_file"; \
	for target in $(SHELL_TARGETS); do \
		echo "shellcheck (rendered) $$target"; \
		chezmoi --config "$$config_file" --source . cat "$$HOME/$$target" > "$$rendered"; \
		shellcheck "$$rendered"; \
	done

check-tmux:
	@set -euo pipefail; \
	if ! command -v tmux >/dev/null 2>&1; then \
		echo "tmux not found; skipping tmux config check"; \
		exit 0; \
	fi; \
	socket="dotfiles-check-$$$$"; \
	trap 'tmux -L "$$socket" kill-server >/dev/null 2>&1 || true' EXIT; \
	tmux -L "$$socket" -f /dev/null new-session -d -s check; \
	echo "tmux source-file dot_tmux.conf"; \
	tmux -L "$$socket" source-file dot_tmux.conf

check-chezmoi:
	@set -euo pipefail; \
	if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "chezmoi not found; skipping template render check"; \
		exit 0; \
	fi; \
	config_file="$$(mktemp "$${TMPDIR:-/tmp}/chezmoi.XXXXXX.yaml")"; \
	rendered="$$(mktemp "$${TMPDIR:-/tmp}/rendered.XXXXXX")"; \
	trap 'rm -f "$$config_file" "$$rendered"' EXIT; \
	printf 'data:\n  pcType: personal\n' > "$$config_file"; \
	for target in $(CHEZMOI_TARGETS); do \
		echo "chezmoi cat $$target"; \
		chezmoi --config "$$config_file" --source . cat "$$HOME/$$target" > "$$rendered"; \
		case "$$target" in \
		*.json) $(PYTHON) -m json.tool "$$rendered" >/dev/null;; \
		esac; \
	done

check-brewfile:
	@set -euo pipefail; \
	if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "chezmoi not found; skipping Brewfile render check"; \
		exit 0; \
	fi; \
	config_file="$$(mktemp "$${TMPDIR:-/tmp}/chezmoi.XXXXXX.yaml")"; \
	brewfile="$$(mktemp "$${TMPDIR:-/tmp}/Brewfile.XXXXXX")"; \
	trap 'rm -f "$$config_file" "$$brewfile"' EXIT; \
	printf 'data:\n  pcType: personal\n' > "$$config_file"; \
	chezmoi --config "$$config_file" --source . cat "$$HOME/.Brewfile" > "$$brewfile"; \
	if ! command -v brew >/dev/null 2>&1; then \
		echo "brew not found; skipping brew bundle check"; \
		exit 0; \
	fi; \
	HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file "$$brewfile" || \
		echo "brew bundle has missing dependencies; run 'brew bundle --global' to install them"
