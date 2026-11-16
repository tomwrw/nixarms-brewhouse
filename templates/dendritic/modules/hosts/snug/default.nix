# The computer called snug: the features it has, and the files and facts
# that belong to it alone. Each computer gets its own folder in
# modules/hosts/, so a second computer is a second folder next to this one.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
# CHANGE ME: if you change the hostname, rename `snug` here and in vm.nix,
# and rename this folder.
{ config, inputs, ... }:
{
  flake.nixosConfigurations.snug = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      desktop
      apps
      gaming
      alice
      vm

      # snug's own disks and drivers. import-tree loads every file in
      # modules/ by itself, as a flake-parts module, except those whose
      # names start with _. This file is a NixOS module for snug alone, so
      # the _ keeps import-tree away from it and only this line loads it.
      ./_hardware-configuration.nix

      {
        networking.hostName = "snug";
        # CHANGE ME: copy this from the configuration.nix the installer gave
        # you, then never change it, even when you upgrade NixOS.
        system.stateVersion = "26.05";
      }
    ];
  };
}
