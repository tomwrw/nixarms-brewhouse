#!/usr/bin/env bash
# Checks every starter with ci/check-starter.sh, then checks the Brewhouse
# promise: the same pint, poured five ways. Every flake starter must build
# exactly the same system as its siblings, down to the last byte of the
# derivation. Only the structure is allowed to differ.
#
# Vanilla is left out of that comparison on purpose. It has no flake, so it
# doesn't switch flakes on, and its NixOS comes from a channel.
#
# Usage: ci/check-all.sh          (BUILD=1 to build every VM too)
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
starters=(vanilla vanilla-hm flakes flakes-hm flake-parts flake-parts-hm dendritic dendritic-hm den den-hm)

declare -A system
failed=()
for name in "${starters[@]}"; do
  echo "::group::$name" >&2
  if system[$name]=$("$root/ci/check-starter.sh" "$name"); then
    echo "$name: ok" >&2
  else
    failed+=("$name")
  fi
  echo "::endgroup::" >&2
done

if ((${#failed[@]})); then
  echo "These starters failed: ${failed[*]}" >&2
  exit 1
fi

same_pint() { # same_pint <label> <starter>...
  local label=$1 first=$2
  shift
  for name in "$@"; do
    if [[ ${system[$name]} != "${system[$first]}" ]]; then
      echo "Not the same pint ($label): $name builds a different system from $first." >&2
      echo "  $first: ${system[$first]}" >&2
      echo "  $name: ${system[$name]}" >&2
      echo "Compare them with: nix run nixpkgs#nix-diff -- ${system[$first]} ${system[$name]}" >&2
      return 1
    fi
  done
  echo "Same pint ($label): $* all build ${system[$first]}" >&2
}

same_pint "without Home Manager" flakes flake-parts dendritic den
same_pint "with Home Manager" flakes-hm flake-parts-hm dendritic-hm den-hm
