# You, in two halves: your account on the NixOS side, and your own apps and
# settings on the Home Manager side. One feature, two kinds of config, one
# file.
# CHANGE ME: rename alice throughout (and this file) to your account name,
# the one you picked in the installer. Then update vm.nix and
# hosts/snug/default.nix.
{ config, ... }:
{
  flake.modules.nixos.alice = {
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
    };

    # Hand Home Manager the other half, below.
    home-manager.users.alice.imports = [ config.flake.modules.homeManager.alice ];
  };

  flake.modules.homeManager.alice =
    { pkgs, ... }:
    {
      # Apps just for you.
      home.packages = [
        pkgs.libreoffice-qt
        pkgs.vlc
      ];

      # Git, with your name on your commits.
      programs.git = {
        enable = true;
        settings = {
          user.name = "Alice"; # CHANGE ME
          user.email = "alice@example.com"; # CHANGE ME
          init.defaultBranch = "main";
        };
      };

      # Bash, with a few shortcuts. Home Manager writes your ~/.bashrc from
      # this.
      programs.bash = {
        enable = true;
        shellAliases = {
          ll = "ls -lh";
          ".." = "cd ..";
        };
      };

      # The Home Manager release you started on. Leave it alone after that,
      # even when you upgrade.
      home.stateVersion = "26.05";
    };
}
