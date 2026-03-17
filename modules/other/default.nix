{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.other;
in {
  options.my.modules.other = {
    enable = lib.mkEnableOption "Misc apps";
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
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
    # Syncthing ports, can't use option because it needs system service enabled
    networking.firewall = {
      allowedTCPPorts = [22000];
      allowedUDPPorts = [
        21027
        22000
      ];
    };

    environment.systemPackages = with pkgs; [
      libreoffice-fresh
      mpv
      imagemagick
    ];
  };
}
