{
  osConfig,
  lib,
  ...
}: let
  cfg = osConfig.my.modules.gaming;
in {
  config = lib.mkIf cfg.enable {
    programs.vesktop.enable = true;
    my.home.modules.lutris.enable = true;
  };
}
