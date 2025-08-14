#!/bin/bash

check_install() {
  max_size=0
  for prog in "$@"; do
    if [ "$max_size" -lt "${#prog}" ]; then
      max_size="${#prog}"
    fi
  done
  for prog in "$@"; do
    printf "%${max_size}s:" "${prog}"
    if type -a "${prog}" &>/dev/null; then
      echo -e "\033[1;32m" "found\033[0m"
    else
      echo -e "\033[1;31m" "not found\033[0m"
    fi
  done
}

# check good-to-have binaries
echo -e "[+] check if well-used binaries are installed..."
REQ_BIN=(brew tmux g++ rustc git python3 clangd make cmake gdb gcc fzf docker htop luajit uv vim nvim ripgrep typst delta)
mapfile -t REQ_LIST <<<"$(printf "%s\n" "${REQ_BIN[@]}" | sort)"

check_install "${REQ_LIST[@]}"
