{
  flake.modules.nixos.tailscale = {
    config,
    lib,
    ...
  }: {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "client";
      # authKeyFile = config.sops.secrets."tailscale/authkey".path;
      # extraUpFlags = ["--ssh"];
    };
  };
}
