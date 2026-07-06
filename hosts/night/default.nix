{...}: {
  imports = [
    ../../modules
  ];

  # Global options
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
      gaming.enable = true;
      garbageCollect.enable = true;
      hyprland.enable = true;
      # plasma.enable = true;
      networking.enable = true;
      nvidia.enable = true;
      other.enable = true;
      plymouth.enable = true;
      work.enable = false;
    };
  };

  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];

  system.stateVersion = "25.11"; # Don't ever change this
}
