{
  config,
  lib,
  pkgs,
  ...
}: {
  options.apps.others = {
    enable = lib.mkEnableOption "Misc apps";
  };
  config = lib.mkIf config.apps.others.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      libreoffice-fresh
    ];
  };
}
