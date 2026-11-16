# What every machine gets: booting, networking, language and Nix itself.
{
  den.aspects.base = {
    nixos = {
      # Boot with systemd-boot, the installer's choice on modern (UEFI) PCs.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.networkmanager.enable = true;

      time.timeZone = "Europe/London"; # CHANGE ME
      i18n.defaultLocale = "en_GB.UTF-8"; # CHANGE ME
      services.xserver.xkb.layout = "gb"; # CHANGE ME
      console.useXkbConfig = true; # the same layout in the text console

      # Flakes are still marked experimental, so switch them on for good.
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
