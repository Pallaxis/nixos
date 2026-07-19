{
  config,
  lib,
  ...
}: let
  cfg = config.my.template;
in {
  options.my.template.enable =
    lib.mkEnableOption "Template";
  config = lib.mkEnable cfg.enable {};
}
