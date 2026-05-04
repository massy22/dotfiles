SHELL := /bin/bash
PYTHON ?= python3

JSON_FILES := $(shell git ls-files '*.json' ':!:*.tmpl')
TOML_FILES := $(shell git ls-files '*.toml')
ZSH_FILES := dot_zshrc dot_zshrc.custom dot_zshrc.alias dot_zshrc.os_darwin dot_zshrc.os_linux
SHELLCHECK_FILES := dot_local/bin/executable_socks-proxy dot_local/bin/executable_used-mem
CHEZMOI_TARGETS := .zshrc .gitconfig .gitconfig.local .zshrc.local .ssh/config .claude/settings.json .gemini/settings.json

.PHONY: check check-json check-toml check-zsh check-shell check-chezmoi

check: check-json check-toml check-zsh check-shell check-chezmoi

check-json:
	@set -euo pipefail; \
	if [ -z "$(JSON_FILES)" ]; then \
		echo "No JSON files to check"; \
		exit 0; \
	fi; \
	for file in $(JSON_FILES); do \
		echo "json $$file"; \
		$(PYTHON) -m json.tool "$$file" >/dev/null; \
	done

check-toml:
	@$(PYTHON) -c 'import pathlib, subprocess, tomllib; files = subprocess.check_output(["git", "ls-files", "*.toml"], text=True).splitlines(); [tomllib.load(open(pathlib.Path(f), "rb")) for f in files]; print("toml checked: {}".format(len(files)))'

check-zsh:
	@if ! command -v zsh >/dev/null 2>&1; then \
		echo "zsh not found; skipping zsh syntax check"; \
		exit 0; \
	fi; \
	for file in $(ZSH_FILES); do \
		echo "zsh -n $$file"; \
		zsh -n "$$file"; \
	done

check-shell:
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "shellcheck not found; skipping shell script check"; \
		exit 0; \
	fi; \
	shellcheck $(SHELLCHECK_FILES)

check-chezmoi:
	@if ! command -v chezmoi >/dev/null 2>&1; then \
		echo "chezmoi not found; skipping template render check"; \
		exit 0; \
	fi; \
	config_file="$$(mktemp "$${TMPDIR:-/tmp}/chezmoi.XXXXXX.yaml")"; \
	trap 'rm -f "$$config_file"' EXIT; \
	printf 'data:\n  pcType: personal\n' > "$$config_file"; \
	for target in $(CHEZMOI_TARGETS); do \
		echo "chezmoi cat $$target"; \
		chezmoi --config "$$config_file" --source . cat "$$HOME/$$target" >/dev/null; \
	done
