# A second flake-parts module, with one job: `nix run .#vm`, which boots
# this config in a throwaway virtual machine.
{ self, ... }:
{
  perSystem.packages.vm = self.nixosConfigurations.snug.config.system.build.vm;
}
