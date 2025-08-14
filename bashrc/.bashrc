case "$0" in
-sh | sh | */sh) modules_shell=sh ;;
-ksh | ksh | */ksh) modules_shell=ksh ;;
-zsh | zsh | */zsh) modules_shell=zsh ;;
-bash | bash | */bash) modules_shell=bash ;;
esac
module() { eval $(/usr/bin/tclsh /usr/share/Modules/libexec/modulecmd.tcl "$modules_shell" "$*"); }

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

CUR_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
TERM=screen-256color

for script in "${CUR_PATH}"/bash/.*; do
  if [ -f "${script}" ]; then
    . "${script}"
  fi
done

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
force_color_prompt=yes

[ -f ~/.fzf.bash ] && source "$HOME/.fzf.bash"

if type -a fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

[ -f ~/.cargo/env ] && source "$HOME/.cargo/env"
