# Home Manager, as a feature like any other. Turning it on is a NixOS
# setting; what it manages for you lives in users/alice.nix.
{ inputs, ... }:
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true; # share the system's packages, so there's one version of each
      useUserPackages = true;
      backupFileExtension = "backup"; # keeps any dotfiles you already have as *.backup
    };
  };
}
