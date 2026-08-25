{
  flake.modules.nixos.nixflix = {
    networking.firewall.allowedTCPPorts = [
      80 # http
      443 # https
    ];

    services.nginx = {
      enable = true;
      virtualHosts = {
        # Root Domain
        "paradise.net" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
          };
        };
      };
    };
  };
}
