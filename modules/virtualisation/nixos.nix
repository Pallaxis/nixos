{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.virtualisation;
in {
  options = {
    my.virtualisation = {
      enable = lib.mkEnableOption "Virtualisation";
    };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };
    programs.virt-manager.enable = true;
  };
}
