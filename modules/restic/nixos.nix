{
  config,
  lib,
  ...
}: let
  cfg = config.my.restic;
in {
  options.my.restic.enable =
    lib.mkEnableOption "Restic";
  config =
    lib.mkIf cfg.enable {
    };
}
