{
  flake.modules.nixos.networking = {
    networking = {
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
        # DNSOverTLS = true;
        # DNSSEC = true;
      };
    };
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns4 = true;
      nssmdns6 = true;
    };
  };
}
