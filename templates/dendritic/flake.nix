# The dendritic pattern: every file in modules/ is a flake-parts module, and
# import-tree loads them all, so adding a feature means adding a file. Files
# are organised by feature (desktop, gaming, you), not by machine.
{
  description = "The Nix Arms Brewhouse: the dendritic starter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
