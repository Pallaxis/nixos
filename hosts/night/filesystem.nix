{ ... }:

{
  boot.initrd.luks.devices = {
    nixos-root = {
      device = "/dev/disk/by-uuid/daf4fdf1-dbf2-45d6-993a-75bd9636f471";
      preLVM = true;
    };
  };
  fileSystems."/" = {
    device = "/dev/mapper/nixos-root";
    fsType = "btrfs";
  };
  swapDevices = [{
    device = "/.swapvol/swapfile";
  }];
  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];
}
