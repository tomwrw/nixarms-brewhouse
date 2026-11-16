# One computer: the features it has, and the few facts that belong to it
# alone. A second computer is a second file in this folder.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
# CHANGE ME: if you change the hostname, rename `snug` here, rename this
# file, and update vm.nix.
{ config, inputs, ... }:
{
  flake.nixosConfigurations.snug = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      desktop
      apps
      gaming
      home-manager
      alice
      vm
      ../../hardware-configuration.nix
      {
        networking.hostName = "snug";
        # CHANGE ME: copy this from the configuration.nix the installer gave
        # you, then never change it, even when you upgrade NixOS.
        system.stateVersion = "26.05";
      }
    ];
  };
}
