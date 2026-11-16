# PLACEHOLDER. Swap this file for your computer's own:
#
#   cp /etc/nixos/hardware-configuration.nix .
#
# Until you do, only the test VM will build. The VM brings its own disks, so
# it never reads fileSystems below; a real build stops there with a reminder.
{
  nixpkgs.hostPlatform = "x86_64-linux";
  fileSystems."/" =
    throw "hardware-configuration.nix is still the Brewhouse placeholder. Copy yours in first: cp /etc/nixos/hardware-configuration.nix .";
}
