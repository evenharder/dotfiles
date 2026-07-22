#!/usr/bin/env zsh
# Enables the full chezmoi-managed dotfiles for this login session only,
# via ZDOTDIR. Useful in shared machines.
#
# Copy this to your own bin dir (e.g. ~/foo/chezmoi-toggle.sh) and run.
set -euo pipefail

SRC="$HOME/.local/share/chezmoi"  # chezmoi config path
LIVE="$PWD"                       # chezmoi destination path

mkdir -p "$LIVE"
chezmoi apply --source "$SRC" --destination "$LIVE"

echo "[chezmoi] entering full session (exit to leave, nothing persists for other users)"
exec env ZDOTDIR="$LIVE" zsh -l
