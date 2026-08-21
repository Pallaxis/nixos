{
  flake.modules.nixos.nixflix = {
    config,
    ...
  }: let
    admin = "henry";
  in {
    sops = {
      age.keyFile = "${config.users.users.${admin}.home}/.config/sops/age/homelab-key.txt";
      defaultSopsFile = ../../../secrets/homelab.yaml;
      secrets = {
        "qbittorrent/password" = {};
        "qbittorrent/password_hash" = {};
        "sonarr/api_key" = {};
        "sonarr/password" = {};
        "radarr/api_key" = {};
        "radarr/password" = {};
        "lidarr/api_key" = {};
        "lidarr/password" = {};
        "prowlarr/api_key" = {};
        "prowlarr/password" = {};
        "jellyfin/api_key" = {};
        "jellyfin/password" = {};
        "seerr/api_key" = {};
        "wireguard/conf" = {};
        # "sabnzbd/api_key" = {};
        # "sabnzbd/nzb_key" = {};
        # "sabnzbd/username" = {};
        # "sabnzbd/password" = {};
        # "usenet/eweka/username" = {};
        # "usenet/eweka/password" = {};
        # "usenet/newsgroupdirect/username" = {};
        # "usenet/newsgroupdirect/password" = {};
        # "indexer-api-keys/DrunkenSlug" = {};
        # "indexer-api-keys/NZBFinder" = {};
        # "indexer-api-keys/NzbPlanet" = {};
      };
    };
  };
}
