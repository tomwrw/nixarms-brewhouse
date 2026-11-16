# The desktop: KDE Plasma with SDDM as the login screen, plus sound and
# printing.
{
  den.aspects.desktop = {
    nixos = {
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      services.printing.enable = true;
    };
  };
}
