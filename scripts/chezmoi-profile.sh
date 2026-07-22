#!/usr/bin/env zsh
# Manage several isolated chezmoi setups under one (possibly shared) account.
# Each profile <p> gets its own namespace, so users sharing a login don't
# clobber each other:
#
#   source           ~/.local/share/chezmoi-<p>
#   config           ~/.config/chezmoi-<p>/chezmoi.toml
#   persistent-state ~/.config/chezmoi-<p>/chezmoistate.boltdb
#   cache            ~/.cache/chezmoi-<p>
#
# The reserved profile "default" runs bare chezmoi (built-in, XDG-aware paths).
# Scoping is via flags: chezmoi has no CHEZMOI_* env-var equivalents for them.
set -euo pipefail

prog=${0:t}

# --- messaging -----------------------------------------------------------
die()  { print -ru2 -- "$prog: $*"; exit 1; }
warn() { print -ru2 -- "$prog: $*"; }

require_profile() { [[ -n ${1:-} ]] || die "missing <profile> (try '$prog list')"; }

# Set CZ_SRC/CZ_CFGDIR/CZ_CFG/CZ_STATE/CZ_CACHE for profile $1 (no subshells).
cz_paths() {
  local base=chezmoi-$1
  CZ_SRC=$HOME/.local/share/$base
  CZ_CFGDIR=$HOME/.config/$base
  CZ_CFG=$CZ_CFGDIR/chezmoi.toml
  CZ_STATE=$CZ_CFGDIR/chezmoistate.boltdb
  CZ_CACHE=$HOME/.cache/$base
}

# Run chezmoi scoped to a profile ("default" -> bare chezmoi).
_cz() {
  local p=$1; shift
  if [[ $p == default ]]; then
    chezmoi "$@"
  else
    cz_paths "$p"
    chezmoi \
      --source           "$CZ_SRC" \
      --config           "$CZ_CFG" \
      --persistent-state "$CZ_STATE" \
      --cache            "$CZ_CACHE" \
      "$@"
  fi
}

# --- commands ------------------------------------------------------------
cmd_init() {
  require_profile "${1:-}"
  local p=$1 repo=${2:-} dest=${3:-}
  [[ $p != default ]] || die "'default' is reserved for the non-namespaced setup"
  [[ -n $repo ]]      || die "usage: $prog init <profile> <repo-url> [dest]"

  cz_paths "$p"
  mkdir -p "$CZ_CFGDIR"
  _cz "$p" init "$repo"

  if [[ -n $dest ]]; then
    if grep -qE '^[[:space:]]*destDir[[:space:]]*=' "$CZ_CFG" 2>/dev/null; then
      warn "destDir already set in $CZ_CFG (repo template); leaving it. requested: $dest"
    else
      printf 'destDir = "%s"\n' "$dest" >> "$CZ_CFG"
    fi
    mkdir -p "$dest"
  fi

  _cz "$p" apply
  print -r -- "[chezmoi:$p] initialized -> source $CZ_SRC"
  [[ -f $CZ_SRC/scripts/chezmoi-profile.sh ]] && \
    print -r -- "  tip: '$prog link $p' to run this helper from the clone (fresh via '$prog update $p')"
}

# apply / diff / update: same passthrough, fixed verb.
run_sub() {
  local verb=$1; shift
  require_profile "${1:-}"
  local p=$1; shift
  _cz "$p" "$verb" "$@"
}

cmd_exec() { require_profile "${1:-}"; local p=$1; shift; _cz "$p" "$@"; }

cmd_session() {
  require_profile "${1:-}"
  local p=$1 dest=${2:-}
  [[ -n $dest ]] || dest=$(_cz "$p" execute-template '{{ .chezmoi.destDir }}')
  [[ -n $dest ]] || die "could not determine destination for profile '$p'"

  mkdir -p "$dest"
  _cz "$p" apply --destination "$dest"
  print -r -- "[chezmoi:$p] entering session at $dest (exit to leave; nothing persists for other users)"
  exec env ZDOTDIR="$dest" zsh -l
}

cmd_list() {
  local d name
  [[ -d "$HOME/.local/share/chezmoi" ]] && print -r -- "default"
  for d in "$HOME"/.local/share/chezmoi-*(N/); do
    name=${d:t}; print -r -- "${name#chezmoi-}"
  done
}

# Point a PATH copy of this helper at the git-tracked one in the profile's
# clone, so `update` (git pull) keeps it fresh instead of drifting.
cmd_link() {
  require_profile "${1:-}"
  local p=$1 target=${2:-$HOME/.local/bin/chezmoi-profile.sh}
  cz_paths "$p"
  local tracked=$CZ_SRC/scripts/chezmoi-profile.sh
  [[ -f $tracked ]] || die "profile '$p' repo has no scripts/chezmoi-profile.sh to link"
  mkdir -p "${target:h}"
  ln -sf "$tracked" "$target"
  print -r -- "[chezmoi:$p] linked $target -> $tracked"
}

cmd_remove() {
  require_profile "${1:-}"
  local p=$1 ans
  [[ $p != default ]] || die "refusing to remove the default setup"
  cz_paths "$p"
  print -rn -- "Remove profile '$p' (source/config/state/cache; applied files are NOT touched)? [y/N] "
  read -r ans
  [[ $ans == [yY]* ]] || { print -r -- "aborted"; return 0; }
  rm -rf -- "$CZ_SRC" "$CZ_CFGDIR" "$CZ_CACHE"
  print -r -- "[chezmoi:$p] removed namespace (applied files left untouched)"
}

usage() {
  cat <<EOF
$prog — manage multiple chezmoi profiles under one account

usage: $prog <command> [args]

  init <profile> <repo-url> [dest]  clone repo into an isolated namespace,
                                    pin dest (if given), then apply
  apply    <profile> [chezmoi args] apply the profile
  diff     <profile> [chezmoi args] preview changes
  update   <profile>                git pull + apply
  session  <profile> [dest]         apply, then open a login shell rooted at
                                    dest via ZDOTDIR
  exec     <profile> -- <args>      run any chezmoi subcommand in the namespace
  link     <profile> [target]       symlink this helper to the profile's
                                    git-tracked copy (default ~/.local/bin)
  list                              list known profiles
  remove   <profile>                delete a profile's namespace
  help                              show this help

The reserved profile "default" targets chezmoi's built-in locations.
EOF
}

# --- dispatch ------------------------------------------------------------
[[ $# -ge 1 ]] || { usage; exit 1; }
cmd=$1; shift
case $cmd in
  init)              cmd_init "$@" ;;
  apply|diff|update) run_sub "$cmd" "$@" ;;
  session)           cmd_session "$@" ;;
  exec)              cmd_exec "$@" ;;
  link)              cmd_link "$@" ;;
  list|ls)           cmd_list "$@" ;;
  remove|rm)         cmd_remove "$@" ;;
  help|-h|--help)    usage ;;
  *)                 die "unknown command: $cmd (try '$prog help')" ;;
esac
