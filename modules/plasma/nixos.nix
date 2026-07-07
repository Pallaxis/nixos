{
  config,
  lib,
  ...
}: let
  cfg = config.my.plasma;
in {
  options.my.plasma.enable =
    lib.mkEnableOption "Plasma";

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;
  };
}
