{inputs, ...}: {
  flake.modules.nixos.homelab = {
    imports = with inputs.self.factory; [
      (diskoBtrfsLuks {
        device = "/dev/nvme0n1";
        swapSize = "8G";
      })
    ];
  };
}
