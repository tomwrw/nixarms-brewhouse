# One computer, as a flake-parts module. A second computer would be a second
# file in this folder, and a line in flake.nix's imports.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
# CHANGE ME: if you change the hostname, rename `snug` here, rename this
# file, and update vm.nix.
{ inputs, ... }:
{
  flake.nixosConfigurations.snug = inputs.nixpkgs.lib.nixosSystem {
    modules = [ ../configuration.nix ];
  };
}
