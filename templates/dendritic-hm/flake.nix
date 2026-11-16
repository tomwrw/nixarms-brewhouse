# The dendritic pattern: every file in modules/ is a flake-parts module, and
# import-tree loads them all, so adding a feature means adding a file. Files
# are organised by feature (desktop, gaming, you), not by machine.
{
  description = "The Nix Arms Brewhouse: the dendritic starter, with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    # Home Manager's release has to match NixOS's.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # use our nixpkgs, not a second copy
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
