{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.quickshell;
in {
  options.my.home.modules.quickshell.enable =
    lib.mkEnableOption "Quickshell";

  config = lib.mkIf cfg.enable {
    xdg.configFile."quickshell".source = ../quickshell;
    programs.quickshell = {
      enable = true;
    };
  };
}
