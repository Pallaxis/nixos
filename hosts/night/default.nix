{lib, ...}: {
  imports = [
    ../../modules
  ];

  my = {
    host = {
      role = "desktop";
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/disk/by-id/nvme-eui.00000000000000000026b768622a1055";
        swapSize = "32G";
      };
    };
  };

  bluetooth.enable = true;
  hardware.nvidia.enable = true;
  apps.gaming.enable = true;

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
