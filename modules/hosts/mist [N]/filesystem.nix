{inputs, ...}: {
  flake.modules.nixos.mist = {
    imports = with inputs.self.factory; [
      (diskoBtrfsLuks {
        device = "/dev/disk/by-id/wwn-0x5001b44a8a722190";
        swapSize = "4G";
      })
    ];
  };
}
