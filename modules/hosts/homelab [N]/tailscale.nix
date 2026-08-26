{
  flake.modules.nixos.homelab = {
    # Exit node config
    services.tailscale = {
      useRoutingFeatures = "server";
      extraSetFlags = ["--advertise-exit-node"];
    };

    # Nixflix + Tailscale serve (uses nixflix default domain)
    services.tailscale.serve = {
      enable = true;
      services = {
        nixflix = {
          endpoints = {
            "tcp:443" = "http://localhost:443";
          };
        };
      };
    };
  };
}
