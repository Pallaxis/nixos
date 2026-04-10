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
    hardware = {
      graphics.enable = true;
      nvidia.open = true;
      nvidia.modesetting.enable = true;
    };
    services.xserver.videoDrivers = ["nvidia"];

    #FIXME: check this works for loading nvidia drivers early
    boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  };
}
