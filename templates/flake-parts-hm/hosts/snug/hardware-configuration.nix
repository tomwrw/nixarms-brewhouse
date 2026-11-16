# PLACEHOLDER. Swap this file for your computer's own. From the top folder
# of this config:
#
#   cp /etc/nixos/hardware-configuration.nix hosts/snug/hardware-configuration.nix
#
# Until you swap it, only the test VM will build. The VM brings its own disks,
# so it never reads fileSystems below; a real build stops there with a
# reminder.
{
  nixpkgs.hostPlatform = "x86_64-linux";
  fileSystems."/" =
    throw "hosts/snug/hardware-configuration.nix is still the Brewhouse placeholder. Copy yours over it first: cp /etc/nixos/hardware-configuration.nix hosts/snug/hardware-configuration.nix";
}
