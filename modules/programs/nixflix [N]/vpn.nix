{
  flake.modules.nixos.nixflix = {config, ...}: {
    nixflix.vpn = {
      enable = true;
      wgConfFile = config.sops.secrets."wireguard/conf".path;
      accessibleFrom = ["192.168.68.0/22"];
    };
  };
}
