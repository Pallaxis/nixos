{
  osConfig,
  lib,
  ...
}: let
  cfg = osConfig.my.gaming;
in {
  config = lib.mkIf cfg.enable {
    programs.vesktop.enable = true;
  };
}
