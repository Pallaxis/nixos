{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.niri;
in {
  options.my.modules.niri.enable =
    lib.mkEnableOption "Niri";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
  };
}
