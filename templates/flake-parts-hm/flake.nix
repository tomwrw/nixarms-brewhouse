# flake-parts splits a flake into modules, so each job gets its own file
# instead of one long flake.nix. This file only lists the inputs and the
# modules; hosts/snug.nix and vm.nix do the work.
{
  description = "The Nix Arms Brewhouse: the flake-parts starter, with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Home Manager's release has to match NixOS's.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # use our nixpkgs, not a second copy
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./hosts/snug.nix
        ./vm.nix
      ];
    };
}
