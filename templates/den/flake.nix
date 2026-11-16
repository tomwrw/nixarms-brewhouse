# den is a framework: you describe your hosts and users once, then build them
# from aspects, which are named features like "desktop" or "gaming". Here it
# sits on flake-parts and import-tree, so every file in modules/ is loaded
# automatically.
{
  description = "The Nix Arms Brewhouse: the den starter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    # den is young and changes quickly, so it's pinned to a release. Read its
    # release notes before you move to a newer one.
    den.url = "github:denful/den/v0.20.0";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
