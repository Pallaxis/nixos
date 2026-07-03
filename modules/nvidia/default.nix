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

    # TODO: test me, should allow nvidia driver to work before unlock
    # boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    # boot.kernelParams = [
    #   "nvidia-drm.modeset=1"
    #   "nvidia-drm.fbdev=1"
    # ];
  };
}
