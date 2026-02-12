{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.lutris;
in {
  options.my.home.modules.lutris.enable =
    lib.mkEnableOption "Lutris";

  config = lib.mkIf cfg.enable {
    programs.lutris = {
      enable = true;
      protonPackages = [
        pkgs.proton-ge-bin
      ];
    };

    home.packages = [
      pkgs.gamma-launcher
    ];
  };
}
