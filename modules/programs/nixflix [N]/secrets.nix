{
  flake.modules.nixos.nixflix = {
    sops = {
      secrets = builtins.listToAttrs (map (name: {
          inherit name;
          # NOTE: homelab key must be merged into system-core-age-key.txt for this to work
          value = {sopsFile = ../../../secrets/homelab.yaml;};
        }) [
          "qbittorrent/password"
          "qbittorrent/password_hash"
          "sonarr/api_key"
          "sonarr/password"
          "radarr/api_key"
          "radarr/password"
          "lidarr/api_key"
          "lidarr/password"
          "prowlarr/api_key"
          "prowlarr/password"
          "jellyfin/api_key"
          "jellyfin/password"
          "seerr/api_key"
          "wireguard/conf"
          # "sabnzbd/api_key"
          # "sabnzbd/nzb_key"
          # "sabnzbd/username"
          # "sabnzbd/password"
          # "usenet/eweka/username"
          # "usenet/eweka/password"
          # "usenet/newsgroupdirect/username"
          # "usenet/newsgroupdirect/password"
          # "indexer-api-keys/DrunkenSlug"
          # "indexer-api-keys/NZBFinder"
          # "indexer-api-keys/NzbPlanet"
        ]);
    };
  };
}
