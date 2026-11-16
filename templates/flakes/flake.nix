# A flake pins the exact version of everything it uses in flake.lock, so this
# config builds the same today, next month and on someone else's computer.
{
  description = "The Nix Arms Brewhouse: the flakes starter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    {
      # Switch to it: sudo nixos-rebuild switch --flake .#snug
      # CHANGE ME: if you change the hostname, rename `snug` here and below.
      nixosConfigurations.snug = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
      };

      # Try it in a throwaway virtual machine: nix run .#vm
      packages.x86_64-linux.vm = self.nixosConfigurations.snug.config.system.build.vm;
    };
}
