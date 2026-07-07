{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  cfg = osConfig.my.lutris;
in {
  config = lib.mkIf cfg.enable {
    programs.lutris = {
      enable = true;
      extraPackages = with pkgs; [
        umu-launcher
      ];
      protonPackages = [
        pkgs.proton-ge-bin
      ];
    };

    home.packages = [
      pkgs.gamma-launcher
    ];
  };
}
