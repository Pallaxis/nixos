{
  flake.modules.nixos.nvidia = {
    hardware = {
      graphics.enable = true;
      nvidia.open = true;
      nvidia.modesetting.enable = true;
      nvidia.powerManagement.enable = true;
    };
    services.xserver.videoDrivers = ["nvidia"];

    boot.kernelParams = [
      "nvidia.NVreg_EnableS0ixPowerManagement=1" # enable S0ix support in NVIDIA driver
      "nvme_core.default_ps_max_latency_us=0" # stop NVMe entering a power state it can't wake from
    ];

    # allows nvidia to load in early boot
    # boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    # boot.kernelParams = ["nvidia-drm.fbdev=1"];
  };
}
