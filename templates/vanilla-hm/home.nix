# Your own corner of the computer: the apps and settings that belong to you
# rather than to the whole system. Home Manager reads this file;
# configuration.nix points it here.
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

  # Bash, with a few shortcuts. Home Manager writes your ~/.bashrc from this.
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
}
