{
  config,
  lib,
  ...
}: let
  cfg = config.my.modules.networking;
  hostCfg = config.my.host;
in {
  options.my.modules.networking = {
    enable = lib.mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = hostCfg.name;
      networkmanager.enable = true;
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };

    environment.etc."nsswitch.conf".text = ''
      passwd:    files systemd
      group:     files [success=merge] systemd
      shadow:    files systemd
      sudoers:   files

      hosts:     mymachines mdns_minimal [NOTFOUND=return] files myhostname dns
      networks:  files

      ethers:    files
      services:  files
      protocols: files
      rpc:       files
    '';
  };
}
