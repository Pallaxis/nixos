{inputs, ...}: {
  flake.modules.nixos.zombie = {
    imports = with inputs.self.factory; [
      (diskoBtrfsLuks {
        device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_BTKA21942AL9512A";
        swapSize = "16G";
      })
    ];
  };
}
