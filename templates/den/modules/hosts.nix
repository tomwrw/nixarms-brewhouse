# Every computer, and who uses it. These names are used everywhere else:
# snug becomes the hostname and alice the account name.
#
# Switch to it: sudo nixos-rebuild switch --flake .#snug
{ den, ... }:
{
  # CHANGE ME: your hostname and your account name (the one you picked in the
  # installer). Then rename den.aspects.snug below, users/alice.nix, and the
  # names in aspects/vm.nix to match.
  den.hosts.x86_64-linux.snug.users.alice = { };

  # What snug is: the features it includes, and the facts that are its alone.
  den.aspects.snug = {
    includes = [
      den.aspects.base
      den.aspects.desktop
      den.aspects.apps
      den.aspects.gaming
      den.aspects.vm
    ];

    nixos = {
      imports = [ ../hardware-configuration.nix ];

      # CHANGE ME: copy this from the configuration.nix the installer gave
      # you, then never change it, even when you upgrade NixOS.
      system.stateVersion = "26.05";
    };
  };
}
