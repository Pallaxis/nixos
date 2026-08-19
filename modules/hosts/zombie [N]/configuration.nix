{inputs, ...}: {
  flake.modules.nixos.zombie = {lib, ...}: {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      nvidia

      hyprland
    ];
    networking.hostName = "zombie";

    services.hardware.openrgb.enable = true;

    systemd.tmpfiles.rules = [
      "w /sys/devices/platform/asus-nb-wmi/gpu_mux_mode - - - - 1" # 1 = Hybrid (iGPU drives panel, dGPU offloadable)
    ];

    hardware.nvidia = {
      powerManagement.finegrained = true; # RTD3: requires prime.offload, powers down dGPU when idle
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:5@0:0:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
    services.xserver.videoDrivers = lib.mkForce ["amdgpu" "nvidia"]; # add amdgpu when using offload
  };
}
