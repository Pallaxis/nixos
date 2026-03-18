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
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
      ];
    };

    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = true;
        DNSSEC = true;
      };
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };
  };
}
