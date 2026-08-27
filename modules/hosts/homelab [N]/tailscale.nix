{
  flake.modules.nixos.homelab = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # Exit node config
    services.tailscale = {
      useRoutingFeatures = "server";
      extraSetFlags = ["--advertise-exit-node"];
    };

    # Nixflix exposed as Tailscale Services (VIP): each app gets its own
    # MagicDNS name https://<service>.<tailnet>.ts.net with a trusted cert.
    # Define each Service (jellyfin, seerr, sonarr, radarr, lidarr, prowlarr,
    # qbittorrent) in the Tailscale admin console and approve the host.
    #
    # NOTE: We disable the NixOS serve module because it has a known bug where
    # `tailscale serve set-config` with "tcp:443" + "http://" target defaults to
    # HTTP (no TLS) instead of HTTPS. See:
    #   https://github.com/tailscale/tailscale/issues/18381
    #   https://github.com/nixos/nixpkgs/issues/530174
    # Instead, a custom systemd service registers each endpoint with --https=443.
    services.tailscale.serve = {
      enable = false;
    };

    systemd.services.tailscale-serve-https = {
      description = "Register Tailscale serve endpoints with HTTPS";
      after = [ "tailscaled.service" ];
      requires = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      script = ''
        ${lib.getExe pkgs.tailscale} serve reset || true

        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:jellyfin --https=443 http://localhost:8096
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:seerr --https=443 http://localhost:5055
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:sonarr --https=443 http://localhost:8989
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:radarr --https=443 http://localhost:7878
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:lidarr --https=443 http://localhost:8686
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:prowlarr --https=443 http://localhost:9696
        ${lib.getExe pkgs.tailscale} serve --bg --service=svc:qbittorrent --https=443 http://192.168.15.1:8282
      '';
    };
  };
}
