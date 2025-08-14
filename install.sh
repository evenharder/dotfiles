#!/bin/bash -e

replace_file() {
  oldfile="$1"
  newfile="$2"
  tmp_dir="$3"
  if [ ! -f "${oldfile}" ]; then
    echo "[+] Copy $1 to $2 ..."
    rm -f "${oldfile}"
    ln --symbolic --relative "${newfile}" "${oldfile}"
  elif ! diff "${oldfile}" "${newfile}"; then
    echo "[+] Replace $1 to $2 ..."
    mv "${oldfile}" "${tmp_dir}"
    rm -f "${oldfile}"
    ln --symbolic --relative "${newfile}" "${oldfile}"
  fi
}

replace_dir() {
  olddir="$1"
  newdir="$2"

  if [ ! -d "${olddir}" ]; then
    echo "[+] Copy $1 with $2 ..."
    ln --symbolic --relative "${newdir}" "${olddir}"
  elif [ "$(readlink -f "$olddir")" != "$(readlink -f "$newdir")" ]; then
    echo "[-] directory $olddir found, please manually remove the directory and run"
    echo "    ln --symbolic --relative ${newdir} ${olddir}"
  fi
}

CUR_DIR=$(dirname "$(readlink -f "$0")")

TMP_DIR=$(mktemp -d)

replace_file "$HOME/.bashrc" "${CUR_DIR}/bashrc/.bashrc" "$TMP_DIR"
replace_file "$HOME/.inputrc" "${CUR_DIR}/inputrc/.inputrc" "$TMP_DIR"
replace_file "$HOME/.tmux.conf" "${CUR_DIR}/tmux/.tmux.conf" "$TMP_DIR"
replace_file "$HOME/.tmux.conf.local" "${CUR_DIR}/tmux/.tmux.conf.local" "$TMP_DIR"
replace_file "$HOME/.vimrc" "${CUR_DIR}/vim/.vimrc" "$TMP_DIR"

replace_dir "$HOME/.config/lazygit" "${CUR_DIR}/lazygit"
replace_dir "$HOME/.config/nvim" "${CUR_DIR}/nvim/lazyvim"

if [ ! -z "$(ls -A "${TMP_DIR}")" ]; then
  echo "[+] previous files stored in ${TMP_DIR} (if present)"
fi
