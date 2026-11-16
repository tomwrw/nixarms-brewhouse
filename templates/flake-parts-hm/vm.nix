# A flake-parts module with one job: `nix run .#vm`, which boots snug in a
# throwaway virtual machine. It's a job for the whole flake rather than part of
# one computer, so it sits outside hosts/.
{ self, ... }:
{
  perSystem.packages.vm = self.nixosConfigurations.snug.config.system.build.vm;
}
