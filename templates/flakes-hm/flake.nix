# A flake pins the exact version of everything it uses in flake.lock, so this
# config builds the same today, next month and on someone else's computer.
{
  description = "The Nix Arms Brewhouse: the flakes starter, with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Home Manager's release has to match NixOS's.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # use our nixpkgs, not a second copy
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      # Switch to it: sudo nixos-rebuild switch --flake .#snug
      # CHANGE ME: if you change the hostname, rename `snug` here and below.
      nixosConfigurations.snug = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      # Try it in a throwaway virtual machine: nix run .#vm
      packages.x86_64-linux.vm = self.nixosConfigurations.snug.config.system.build.vm;
    };
}
