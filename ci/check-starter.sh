#!/usr/bin/env bash
# Checks one Brewhouse starter the way a reader would meet it:
#
#   1. Try it: the untouched starter's test VM evaluates, which is what
#      `nix run github:tomwrw/nixarms-brewhouse#<name>` boots.
#   2. The placeholder hardware file stops a real build, with its reminder.
#   3. Take it: after `nix flake init` and a real-looking hardware file, the
#      real system evaluates.
#
# Any evaluation warning fails the check, because warnings worry beginners.
# Set BUILD=1 to build the VM as well as evaluate it.
#
# Prints the reader's system derivation on stdout, so ci/check-all.sh can
# compare starters. Everything else goes to stderr.
#
# Usage: ci/check-starter.sh <name>
set -euo pipefail

name=${1:?usage: ci/check-starter.sh <name>}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
starter="$root/templates/$name"
if [[ ! -d $starter ]]; then
  echo "No starter called $name in templates/." >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

nix() { command nix --extra-experimental-features "nix-command flakes" "$@"; }

# Runs a command, keeping its stderr. Fails if the command fails or if it
# printed a warning.
quietly() {
  if ! "$@" 2>"$work/stderr"; then
    cat "$work/stderr" >&2
    return 1
  fi
  if grep -qi "warning" "$work/stderr"; then
    echo "$name: this printed a warning:" >&2
    cat "$work/stderr" >&2
    return 1
  fi
}

say() { echo "$name: $*" >&2; }

# Vanilla starters have no flake. Evaluate them the classic way, with the
# nixpkgs and Home Manager this repo pins standing in for channels.
if [[ ! -e $starter/flake.nix ]]; then
  (cd "$root" && nix flake archive --json "path:.") >"$work/inputs.json"
  input() {
    nix eval --raw --impure --expr \
      "(builtins.fromJSON (builtins.readFile \"$work/inputs.json\")).inputs.$1.path"
  }
  nixpkgs=$(input nixpkgs)
  home_manager=$(input home-manager)

  classic() { # classic <configuration.nix> <attribute>
    nix eval --raw --impure --file "$nixpkgs/nixos" "$2" --option nix-path "" \
      -I nixos-config="$1" -I nixpkgs="$nixpkgs" -I home-manager="$home_manager"
  }
  build_vm() {
    nix-build "$nixpkgs/nixos" -A vm --no-out-link --option nix-path "" \
      -I nixos-config="$starter/configuration.nix" -I nixpkgs="$nixpkgs" \
      -I home-manager="$home_manager" >/dev/null
  }
  try_vm() { classic "$starter/configuration.nix" vm.drvPath; }
  real_system() { classic "$1/configuration.nix" system.drvPath; }
else
  flake_eval() { # flake_eval <dir> <attribute>
    (cd "$1" && nix eval --raw "path:.#$2")
  }
  build_vm() { (cd "$starter" && nix build --no-link "path:.#vm"); }
  try_vm() { flake_eval "$starter" packages.x86_64-linux.vm.drvPath; }
  real_system() { flake_eval "$1" nixosConfigurations.snug.config.system.build.toplevel.drvPath; }
fi

say "1. try it: the test VM evaluates"
quietly try_vm >/dev/null
if [[ ${BUILD:-0} == 1 ]]; then
  say "   and builds"
  build_vm
fi

say "2. the placeholder hardware file stops a real build"
if real_system "$starter" >/dev/null 2>"$work/stderr"; then
  say "the real system built with the placeholder in place"
  exit 1
fi
if ! grep -q "still the Brewhouse placeholder" "$work/stderr"; then
  say "the real system failed, but not with the placeholder's reminder:"
  cat "$work/stderr" >&2
  exit 1
fi

say "3. take it: nix flake init, add hardware, evaluate the real system"
mkdir "$work/reader"
(cd "$work/reader" && nix flake init -t "path:${root// /%20}#$name" >/dev/null 2>&1)
# Most starters keep the placeholder at the top; den keeps it in its host's
# folder. Find it by its reminder, as a reader would by its comment.
mapfile -t placeholders < <(grep -rl "still the Brewhouse placeholder" "$work/reader")
if ((${#placeholders[@]} != 1)); then
  say "expected one placeholder hardware file, found ${#placeholders[@]}"
  exit 1
fi
cp -f "$root/ci/hardware-configuration.nix" "${placeholders[0]}"
quietly real_system "$work/reader" >"$work/system"

cat "$work/system"
echo
