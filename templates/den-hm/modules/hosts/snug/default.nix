# The computer called snug: who uses it, what it includes, and the files that
# belong to it alone. Each computer gets its own folder in modules/hosts/, so
# a second computer is a second folder next to this one.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
{ den, ... }:
{
  # CHANGE ME: your hostname and your account name (the one you picked in the
  # installer). den uses these names everywhere else: snug becomes the
  # hostname and alice the account name. Rename den.aspects.snug below, this
  # folder, users/alice.nix and the names in aspects/vm.nix to match.
  #
  # classes picks what kinds of config alice gets: `user` for the account,
  # `homeManager` for alice's own apps and settings. Giving anyone the
  # homeManager class is what switches Home Manager on.
  den.hosts.x86_64-linux.snug.users.alice.classes = [
    "user"
    "homeManager"
  ];

  # What snug is: the features it includes, and the facts that are its alone.
  den.aspects.snug = {
    includes = [
      den.aspects.base
      den.aspects.desktop
      den.aspects.apps
      den.aspects.gaming
      den.aspects.home-manager
      den.aspects.vm
    ];

    nixos = {
      # snug's own disks and drivers. import-tree loads every file in
      # modules/ by itself, as a flake-parts module, except those whose
      # names start with _. This file is a NixOS module for snug alone, so
      # the _ keeps import-tree away from it and only this line loads it.
      imports = [ ./_hardware-configuration.nix ];

      # CHANGE ME: copy this from the configuration.nix the installer gave
      # you, then never change it, even when you upgrade NixOS.
      system.stateVersion = "26.05";
    };
  };
}
