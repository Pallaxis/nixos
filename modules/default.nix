{
  config,
  lib,
  ...
}: let
  cfg = config.my.host;
in {
  imports = [
    ./apps
    ./core
    ./disko
    ./flatpak
    ./hardware
    ./hyprland
    ./networking
    ./options
    ./plymouth
  ];
  config = {
    my.modules =
      {
        networking.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "desktop") {
        # fonts.enable = true;
        # my-user.enable = true;
        # sound.enable = true;
        hyprland.enable = true;
        plymouth.enable = true;
        # system-recovery.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "server") {
      };
  };
}
