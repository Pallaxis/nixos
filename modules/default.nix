{
  config,
  lib,
  ...
}: let
  cfg = config.my.host;
in {
  imports = [
    ./core
    ./disko
    ./flatpak
    ./gaming
    ./garbage-collect
    ./hardware
    ./hyprland
    ./networking
    ./options
    ./other
    ./plymouth
    ./work
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
      // lib.optionalAttrs cfg.work {
        work.enable = true;
        others.enable = true;
      };
  };
}
