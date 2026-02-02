{
  config,
  lib,
  ...
}: {
  options.hardware.nvidia = {
    enable = lib.mkEnableOption "Settings for nvidia";
  };
  config = lib.mkIf config.hardware.nvidia.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
  };
}
