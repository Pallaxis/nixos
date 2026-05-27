{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.plasma;
in {
  options.my.modules.plasma.enable =
    lib.mkEnableOption "Plasma";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
