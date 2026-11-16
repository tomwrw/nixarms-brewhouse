# The Nix Arms Brewhouse: ten NixOS starter configs, two for each method.
#
#   Try one in a throwaway VM:  nix run github:tomwrw/nixarms-brewhouse#flakes-hm
#   Take one for yourself:      nix flake init -t github:tomwrw/nixarms-brewhouse#flakes-hm
#   See them all:               nix run github:tomwrw/nixarms-brewhouse
#
# Each starter lives in templates/<name> and is a complete config on its own,
# with its own flake.lock. This file only lists them and makes the commands
# above work. You don't need to read it to use a starter.
{
  description = "The Nix Arms Brewhouse: NixOS starter configs, five methods, with and without Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Only used to try the vanilla-hm starter, which gets Home Manager from a
    # channel on a real computer.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # The five Brewhouse methods, in ladder order. Each one gets two starters:
      # <slug> without Home Manager and <slug>-hm with it.
      methods = [
        {
          slug = "vanilla";
          step = 1;
          title = "Vanilla configuration.nix";
          usesFlakes = false;
        }
        {
          slug = "flakes";
          step = 2;
          title = "Flakes";
          usesFlakes = true;
        }
        {
          slug = "flake-parts";
          step = 3;
          title = "flake-parts";
          usesFlakes = true;
          # Keeps each computer's files together, in its host's folder.
          hardware = "hosts/snug/hardware-configuration.nix";
        }
        {
          slug = "dendritic";
          step = 4;
          title = "The dendritic pattern";
          usesFlakes = true;
          # Keeps each computer's files together, in its host's folder.
          hardware = "modules/hosts/snug/_hardware-configuration.nix";
        }
        {
          slug = "den";
          step = 5;
          title = "den";
          usesFlakes = true;
          # Keeps each computer's files together, in its host's folder.
          hardware = "modules/hosts/snug/_hardware-configuration.nix";
        }
      ];

      variant =
        withHomeManager: method:
        method
        // {
          inherit withHomeManager;
          name = method.slug + lib.optionalString withHomeManager "-hm";
        };

      starters = lib.concatMap (method: [
        (variant false method)
        (variant true method)
      ]) methods;

      describe =
        s:
        "Step ${toString s.step} of 5, ${s.title}, "
        + (if s.withHomeManager then "with Home Manager" else "without Home Manager");

      # Printed straight after `nix flake init`, so the next steps are on screen.
      welcomeText =
        s:
        if s.usesFlakes then
          ''
            # You've poured the ${s.name} starter

            1. Copy in your computer's own hardware file:
               `cp /etc/nixos/hardware-configuration.nix ${s.hardware or "."}`
            2. Search for `CHANGE ME` and fill in your own details.
            3. Switch to it: `sudo nixos-rebuild switch --flake .#snug`

            To try it first, `nix run .#vm` boots it in a throwaway virtual machine.
            If this folder is a git repo, `git add` every file before you build.

            README.md here has the full guide.
            More on this method: https://nixarms.com/brewhouse/${s.slug}/
          ''
        else
          ''
            # You've poured the ${s.name} starter

            This one has no flake. It replaces the files in /etc/nixos, so read
            README.md here first. The short version:

            1. Back up your current config: `sudo cp -r /etc/nixos /etc/nixos.bak`
            2. Search for `CHANGE ME` and fill in your own details.
            3. Copy the .nix files here into /etc/nixos, but keep your own
               hardware-configuration.nix.
            ${
              if s.withHomeManager then
                ''
                  4. Add the Home Manager channel (README.md has the commands).
                  5. Switch to it: `sudo nixos-rebuild switch`''
              else
                "4. Switch to it: `sudo nixos-rebuild switch`"
            }

            More on this method: https://nixarms.com/brewhouse/${s.slug}/
          '';

      # `nix run .#<name>` builds that starter's test VM and boots it. Each
      # starter is evaluated with its own flake.lock, so you try exactly what
      # `nix flake init` would hand you.
      tryStarter =
        s:
        pkgs.writeShellApplication {
          name = "try-${s.name}";
          text =
            if s.usesFlakes then
              ''
                exec nix --extra-experimental-features "nix-command flakes" \
                  run "path:${self}/templates/${s.name}#vm" -- "$@"
              ''
            else
              # Vanilla has no flake, so build it the classic way, using the
              # versions this repo pins in place of your channels.
              ''
                vm=$(nix-build "${nixpkgs}/nixos" -A vm --no-out-link --option nix-path "" \
                  -I nixos-config="${self}/templates/${s.name}/configuration.nix" \
                  -I nixpkgs="${nixpkgs}" \
                  -I home-manager="${home-manager}")
                exec "$vm/bin/run-snug-vm" "$@"
              '';
        };

      # `nix run` on its own prints this list.
      menu = pkgs.writeShellApplication {
        name = "brewhouse";
        text = ''
          cat <<'EOF'
          The Nix Arms Brewhouse: five ways to brew the same pint.

          Every starter builds the same computer: KDE Plasma, Firefox,
          LibreOffice and Steam, for one user. Only the structure changes.

          Try one in a throwaway virtual machine:
            nix run github:tomwrw/nixarms-brewhouse#<name>

          Take one for yourself:
            nix flake init -t github:tomwrw/nixarms-brewhouse#<name>

          ${lib.concatMapStringsSep "\n" (s: "  ${padRight 16 s.name}${describe s}") starters}

          The guide to each method: https://nixarms.com/brewhouse/
          EOF
        '';
      };

      padRight = width: str: str + lib.strings.replicate (width - lib.stringLength str) " ";

      app = description: drv: {
        type = "app";
        program = lib.getExe drv;
        meta = { inherit description; };
      };
    in
    {
      templates = lib.listToAttrs (
        map (s: {
          inherit (s) name;
          value = {
            path = ./templates/${s.name};
            description = describe s;
            welcomeText = welcomeText s;
          };
        }) starters
      );

      apps.${system} =
        lib.listToAttrs (
          map (s: {
            inherit (s) name;
            value = app "Boot the ${s.name} starter in a throwaway VM" (tryStarter s);
          }) starters
        )
        // {
          default = app "List the Brewhouse starters" menu;
        };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
