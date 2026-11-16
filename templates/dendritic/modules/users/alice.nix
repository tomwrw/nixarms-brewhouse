# You: your account, and the apps that are just for you.
# CHANGE ME: rename alice throughout (and this file) to your account name,
# the one you picked in the installer. Then update vm.nix and
# hosts/snug/default.nix.
{
  flake.modules.nixos.alice =
    { pkgs, ... }:
    {
      # initialPassword only counts when the account is first created, so if
      # it's new, change it straight away with `passwd`.
      users.users.alice = {
        isNormalUser = true;
        description = "Alice"; # CHANGE ME
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        initialPassword = "changeme";

        packages = [
          pkgs.libreoffice-qt
          pkgs.vlc
        ];
      };
    };
}
