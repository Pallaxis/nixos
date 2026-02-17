{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.nvidia;
in {
  options.my.modules.nvidia = {
    enable = lib.mkEnableOption "Settings for nvidia";
  };
  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
  };
}
