{
  flake.modules.nixos.blocky = {
    config,
    lib,
    ...
  }: {
    # Blocky binds port 53, which conflicts with resolved
    services.resolved.enable = lib.mkForce false;

    networking.firewall = {
      allowedTCPPorts = [
        53 # dns
      ];
      allowedUDPPorts = [
        53 # dns
      ];
    };

    services.blocky = {
      enable = true;
      settings = {
        upstreams = {
          groups = {
            default = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
        };
        customDNS = {
          mapping = {
            "paradise.net" = "192.168.68.62";
            "*.paradise.net" = "192.168.68.62";
          };
        };
        blocking = {
          denylists = {
            ads = [
              # "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.plus.txt"
            ];
          };
          clientGroupsBlock = {
            default = ["ads"];
          };
        };
      };
    };
  };
}
