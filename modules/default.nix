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
    ./desktop
    ./hardware
    ./networking
    ./options
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
        # system-recovery.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "server") {
      };
  };
}
