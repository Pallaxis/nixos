{
  config,
  lib,
  ...
}: let
  # Maps dirs in current dir to a list of paths
  dirNames = lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ./.));
  importPaths = map (name: ./. + "/${name}") dirNames;

  cfg = config.my.host;
in {
  imports = importPaths;

  config = {
    my.modules =
      {
        networking.enable = true;
        garbageCollect.enable = true;
        other.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "desktop") {
        hyprland.enable = true;
        plymouth.enable = true;
      }
      // lib.optionalAttrs (cfg.role == "server") {
      };
  };
}
