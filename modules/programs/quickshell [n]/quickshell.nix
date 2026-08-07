{
  flake.modules.homeManager.quickshell = {pkgs, ...}: {
    xdg.configFile."quickshell/pallaxis".source = ./pallaxis;
    programs.quickshell = {
      enable = true;
      activeConfig = "pallaxis";
    };
    home.packages = [pkgs.kdePackages.qtdeclarative];
  };
}
