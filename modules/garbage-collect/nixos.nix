{
  config,
  lib,
  ...
}: let
  cfg = config.my.garbageCollect;
in {
  options.my.garbageCollect.enable =
    lib.mkEnableOption "GarbageCollect";

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
