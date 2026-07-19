{
  lib,
  osConfig,
  ...
}: let
  cfg = osConfig.my.template;
in {
  config =
    lib.mkIf cfg.enable {
    };
}
