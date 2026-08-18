{inputs, ...}: {
  flake.modules.nixos.zombie = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      nvidia

      hyprland
    ];
    networking.hostName = "zombie";

    services.hardware.openrgb.enable = true;

    # # # Uncomment to enable PRIME offload (uses iGPU for desktop, dGPU on-demand) # # #
    # Verify bus IDs with: lspci | grep -E "VGA|3D"
    # hardware.nvidia = {
    #   prime = {
    #     offload = {
    #       enable = true;
    #       enableOffloadCmd = true;
    #     };
    #     amdgpuBusId = "PCI:0:1:0"; # AMD Radeon 680M — verify with lspci
    #     nvidiaBusId = "PCI:1:0:0"; # NVIDIA RTX 3070 Mobile — verify with lspci
    #   };
    # };
    # services.xserver.videoDrivers = lib.mkForce ["amdgpu" "nvidia"]; # add amdgpu when using offload
  };
}
