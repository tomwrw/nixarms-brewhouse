# Apps for everyone on the computer.
{
  flake.modules.nixos.apps = {
    programs.firefox.enable = true;
    programs.git.enable = true;
  };
}
