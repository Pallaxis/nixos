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
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      libreoffice-fresh
      mpv
      imagemagick
    ];
  };
}
