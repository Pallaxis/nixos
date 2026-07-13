{
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.tio;
in {
  config = lib.mkIf cfg.enable {
    xdg.configFile."tio/scripts/".source = ./scripts;
  };
}
