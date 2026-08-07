{inputs, ...}: {
  flake.modules.nixos.thinkpad = {
    imports = with inputs.self.factory; [
      (diskoBtrfsLuks {
        device = "/dev/disk/by-id/nvme-TEAM_TM8FP4512G_17A8079402DE00100982";
        swapSize = "16G";
      })
    ];
  };
}
