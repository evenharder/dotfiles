# dotfiles
dotfiles of evenharder. Hope it grows!

## Installation

These dotfiles are managed with [chezmoi](https://www.chezmoi.io/).

### Single user

```sh
chezmoi init --apply evenharder     # clone this repo and apply
```

### Shared account

Use `scripts/chezmoi-profile.sh` so each user's dotfiles stay isolated (own
source, config, state, cache, and destination). Requires `chezmoi` and `git`.

#### Initialization

```sh
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/evenharder/dotfiles/main/scripts/chezmoi-profile.sh \
  -o ~/.local/bin/chezmoi-profile.sh && chmod +x ~/.local/bin/chezmoi-profile.sh
alias cz="$HOME/.local/bin/chezmoi-profile.sh"   # PATH-independent shortener

cz init USER evenharder DEST    # clone -> pin destination directory -> apply
cz link USER                    # repoint ~/.local/bin copy at the git-tracked clone
```

#### Daily Usage

After initialization, use:
- `cz session USER`: enter an ephemeral login shell in USER's chezmoi-based zsh environment
- `cz apply USER`: apply source changes to USER's dotfiles
- `cz update USER`: git pull + apply (refreshes helper as well)

See `cz help` for the full command list. In order to maintain separate chezmoi environments,
`cz` (`chezmoi-profile.sh`) should be used instead of `chezmoi`.

## Future Plans
- apply `kickstart.nvim` instead of `lazyvim`
- get used to `oil.nvim`
- fix buggy lazygit paging colorscheme inside tmuxinator (don't know what's going on)
- possibly add some more lazygit (or git) alias
- add some simple bashrc alias
