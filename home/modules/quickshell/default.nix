{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.quickshell;
in {
  options.my.home.modules.quickshell.enable =
    lib.mkEnableOption "Quickshell";

  config = lib.mkIf cfg.enable {
    xdg.configFile."quickshell/pallaxis".source = ../quickshell/pallaxis;
    programs.quickshell = {
      enable = true;
      activeConfig = "pallaxis";
    };
    home.packages = [pkgs.kdePackages.qtdeclarative];
  };
}
