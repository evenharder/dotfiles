# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

. ~/.config/dotfiles/bash/.path
export PATH

. ~/.config/dotfiles/bash/.aliases
. ~/.config/dotfiles/bash/.exports

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
force_color_prompt=yes
TERM=xterm-256color
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
