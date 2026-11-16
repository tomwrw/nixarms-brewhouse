# `nix run .#vm` boots this config in a throwaway virtual machine. The vm
# feature only changes things inside that VM; your real computer ignores it.
{ self, ... }:
{
  flake.modules.nixos.vm = {
    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 4096; # MB
        cores = 2;
        diskImage = null; # nothing is saved, and nothing is left behind
      };
      services.displayManager.autoLogin = {
        enable = true;
        user = "alice"; # CHANGE ME
      };
    };
  };

  perSystem.packages.vm = self.nixosConfigurations.snug.config.system.build.vm;
}
