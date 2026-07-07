{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = osConfig.my.quickshell;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."quickshell/pallaxis".source = ../quickshell/pallaxis;
    programs.quickshell = {
      enable = true;
      activeConfig = "pallaxis";
    };
    home.packages = [pkgs.kdePackages.qtdeclarative];
  };
}
