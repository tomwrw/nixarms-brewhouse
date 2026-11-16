# den switches Home Manager on by itself for any user with the homeManager
# class (see hosts.nix). This aspect only picks how it behaves.
{
  den.aspects.home-manager.nixos.home-manager = {
    useGlobalPkgs = true; # share the system's packages, so there's one version of each
    useUserPackages = true;
    backupFileExtension = "backup"; # keeps any dotfiles you already have as *.backup
  };
}
