# /etc/nixos/configuration.nix: the whole computer, in one file. Your
# channel decides which version of NixOS builds it; this file decides what
# the computer is.
{ pkgs, ... }:

let
  # CHANGE ME: everything personal lives in this block.
  hostname = "snug";
  username = "alice"; # use the account name you picked in the installer
  fullName = "Alice";
  timezone = "Europe/London";
  locale = "en_GB.UTF-8";
  keyboard = "gb";
  # Copy this from the configuration.nix the installer gave you, then never
  # change it, even when you upgrade NixOS. It isn't the version you run.
  stateVersion = "26.05";
in
{
  imports = [ ./hardware-configuration.nix ];

  # Boot with systemd-boot, the installer's choice on modern (UEFI) PCs.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  services.xserver.xkb.layout = keyboard;
  console.useXkbConfig = true; # the same layout in the text console

  # The desktop: KDE Plasma, with SDDM as the login screen.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Sound through PipeWire, and printing.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.printing.enable = true;

  # Your account. initialPassword only counts when the account is first
  # created, so if it's new, change it straight away with `passwd`.
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    initialPassword = "changeme";

    # Apps just for you.
    packages = [
      pkgs.libreoffice-qt
      pkgs.vlc
    ];
  };

  # Apps for everyone on the computer.
  programs.firefox.enable = true;
  programs.git.enable = true;

  # The pint: Steam. It isn't free software, so NixOS needs your say-so first.
  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;

  # Only for the test VM (`nixos-rebuild build-vm`). Your real computer
  # ignores this.
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096; # MB
      cores = 2;
      diskImage = null; # nothing is saved, and nothing is left behind
    };
    services.displayManager.autoLogin = {
      enable = true;
      user = username;
    };
  };

  system.stateVersion = stateVersion;
}
