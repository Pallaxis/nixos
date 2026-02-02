{lib, ...}: {
  imports = [
    ../../modules/default.nix
  ];

  desktop.hyprland.enable = true;
  bluetooth.enable = true;
  hardware.nvidia.enable = true;
  apps.gaming.enable = true;

  # Hostname
  networking.hostName = "night";

  # Swap file
  swapDevices = lib.mkForce [
    {
      device = "/.swapvol/swapfile";
    }
  ];

  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];

  system.stateVersion = "25.11"; # Don't ever change this
}
