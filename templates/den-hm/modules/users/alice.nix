# You. den hands the `user` class to users.users.alice, and the homeManager
# class to Home Manager, on every computer you're listed on in modules/hosts/.
{
  den.aspects.alice = {
    user = {
      isNormalUser = true;
      description = "Alice"; # CHANGE ME
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      # Only counts when the account is first created, so if it's new,
      # change it straight away with `passwd`.
      initialPassword = "changeme";
    };

    homeManager =
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

        # Bash, with a few shortcuts. Home Manager writes your ~/.bashrc
        # from this.
        programs.bash = {
          enable = true;
          shellAliases = {
            ll = "ls -lh";
            ".." = "cd ..";
          };
        };

        # The Home Manager release you started on. Leave it alone after
        # that, even when you upgrade.
        home.stateVersion = "26.05";
      };
  };
}
