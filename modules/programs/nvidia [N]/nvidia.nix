{
  flake.modules.nixos.nvidia = {
    hardware = {
      graphics.enable = true;
      nvidia.open = true;
      nvidia.modesetting.enable = true;
      nvidia.powerManagement = {
        enable = true;
        # finegrained = true; # Enable after adding prime offload in zombie's configuration.nix
      };
    };
    services.xserver.videoDrivers = ["nvidia"];

    # allows nvidia to load in early boot
    # boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    # boot.kernelParams = ["nvidia-drm.fbdev=1"];
  };
}
