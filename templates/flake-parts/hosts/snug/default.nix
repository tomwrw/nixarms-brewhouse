# snug's place in the flake. This is a flake-parts module: it describes the
# flake, one level up from the computer, so it lives in its own file.
# configuration.nix, next door, describes the computer itself, as a NixOS
# module. Keeping them apart means configuration.nix stays the file you already
# know from the flakes starter.
#
# Everything that belongs to snug is in this folder. A second computer gets a
# folder of its own next to this one, and a line in flake.nix's imports.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
# CHANGE ME: if you change the hostname, rename `snug` here and in vm.nix,
# rename this folder, and update its path in flake.nix.
{ inputs, ... }:
{
  flake.nixosConfigurations.snug = inputs.nixpkgs.lib.nixosSystem {
    modules = [ ./configuration.nix ];
  };
}
