# The pint: Steam. It isn't free software, so NixOS needs your say-so first.
{
  den.aspects.gaming = {
    nixos = {
      nixpkgs.config.allowUnfree = true;
      programs.steam.enable = true;
    };
  };
}
