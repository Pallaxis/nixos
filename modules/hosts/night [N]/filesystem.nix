{inputs, ...}: {
  flake.modules.nixos.night = {
    imports = with inputs.self.factory; [
      (diskoBtrfsLuks {
        device = "/dev/disk/by-id/nvme-eui.00000000000000000026b768622a1055";
        swapSize = "32G";
      })
    ];
  };
}
