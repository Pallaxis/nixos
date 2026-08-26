{inputs, ...}: {
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      system-cli
      ssh
      nixflix
      blocky
    ];
    networking.hostName = "homelab";

    security.sudo.wheelNeedsPassword = false;

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
