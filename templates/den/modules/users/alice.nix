# You. Whatever goes in the `user` class, den hands to users.users.alice on
# every computer you're listed on in modules/hosts/.
{
  den.aspects.alice.user =
    { pkgs, ... }:
    {
      isNormalUser = true;
      description = "Alice"; # CHANGE ME
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      # Only counts when the account is first created, so if it's new,
      # change it straight away with `passwd`.
      initialPassword = "changeme";

      # Apps just for you.
      packages = [
        pkgs.libreoffice-qt
        pkgs.vlc
      ];
    };
}
