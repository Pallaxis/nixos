{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.garbageCollect;
in {
  options.my.modules.garbageCollect.enable =
    lib.mkEnableOption "GarbageCollect";

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
