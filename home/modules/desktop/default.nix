{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.desktop;
in {
  options.my.home.modules.desktop.enable =
    lib.mkEnableOption "Desktop";

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          horizontal-pad = 41;
        };
      };
    };
  };
}
