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
    ./garbage-collect
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
        garbageCollect.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "desktop") {
        hyprland.enable = true;
        plymouth.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "server") {
      };
  };
}
