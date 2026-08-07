{
  flake.modules.nixos.nixflix = {
    config,
    lib,
    ...
  }: {
    sops = {
      age.keyFile = "/home/henry/.config/sops/age/keys.txt";
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
        "jellyfin/henry_password" = {};
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

    networking = {
      firewall = {
        allowedTCPPorts = [
          80 # http
          443 # https
          53 # dns
        ];
        allowedUDPPorts = [
          53 # dns
        ];
      };
    };

    services = {
      homepage-dashboard = {
        # enable = true;
      };
      resolved.enable = lib.mkForce false; # conflicts with port 53 for dns
      # should break into its own module, not related to nixflix
      blocky = {
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
      nginx = {
        enable = true;
        virtualHosts = {
          # Root Domain
          "paradise.net" = {
            locations."/" = {
              proxyPass = "http://127.0.0.1:8096";
            };
          };

          # # Jellyfin
          # "jellyfin.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:8096";
          #     proxyWebsockets = true; # Required for Jellyfin's real-time features
          #   };
          # };
          #
          # # Sonarr
          # "sonarr.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:8989";
          #     proxyWebsockets = true;
          #   };
          # };
          #
          # # Radarr
          # "radarr.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:7878";
          #   };
          # };
          #
          # # Prowlarr
          # "prowlarr.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:9696";
          #   };
          # };
          #
          # # qBittorrent
          # "qbittorrent.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:8282";
          #   };
          # };
          #
          # "seerr.paradise.net" = {
          #   locations."/" = {
          #     proxyPass = "http://127.0.0.1:5055";
          #   };
          # };
        };
      };
    };
    nixflix = {
      enable = true;
      mediaUsers = ["henry"];

      theme = {
        enable = true;
        name = "overseerr";
      };
      postgres.enable = true;

      nginx = {
        enable = true;
        addHostsEntries = true;
        domain = "paradise.net";
      };

      sonarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."sonarr/api_key".path;
          hostConfig = {
            username = "henry";
            password._secret = config.sops.secrets."sonarr/password".path;
          };
        };
      };

      radarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."radarr/api_key".path;
          hostConfig = {
            username = "henry";
            password._secret = config.sops.secrets."radarr/password".path;
          };
        };
      };

      recyclarr = {
        enable = true;
        cleanupUnmanagedProfiles.enable = true;
      };

      lidarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."lidarr/api_key".path;
          hostConfig = {
            username = "henry";
            password._secret = config.sops.secrets."lidarr/password".path;
          };
        };
      };

      prowlarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
          hostConfig = {
            username = "henry";
            password._secret = config.sops.secrets."prowlarr/password".path;
          };

          indexers = [
            {
              name = "The Pirate Bay";
            }
            # {
            #   name = "DrunkenSlug";
            #   apiKey._secret = config.sops.secrets."indexer-api-keys/DrunkenSlug".path;
            # }
            #
            # {
            #   name = "NZBFinder";
            #   apiKey._secret = config.sops.secrets."indexer-api-keys/NZBFinder".path;
            # }
            #
            # {
            #   name = "NzbPlanet";
            #   apiKey._secret = config.sops.secrets."indexer-api-keys/NzbPlanet".path;
            # }
          ];
        };
      };

      torrentClients.qbittorrent = {
        enable = true;
        password._secret = config.sops.secrets."qbittorrent/password".path;
        serverConfig = {
          Preferences.WebUI = {
            Username = "henry";
            Password_PBKDF2 = "@ByteArray(4Fax2nH7DR6tK5KQtuMQCA==:Pq+4D+wUMdF05IIXKwksO7qGT5QQpSwDALRSime+Yk/z34/5zADJLvRk3kkx2QVw2VcgL4PGkWtoBKccPofWUQ==)";

            # this is just needed to avoid ssl fuckery with css
            CSRFProtection = false;
            HostHeaderValidation = false;
          };
        };
      };
      downloadarr = {
        enable = true;
        sabnzbd = {
          enable = false;
          settings = {
            misc = {
              api_key._secret = config.sops.secrets."sabnzbd/api_key".path;
              nzb_key._secret = config.sops.secrets."sabnzbd/nzb_key".path;
              username._secret = config.sops.secrets."sabnzbd/username".path;
              password._secret = config.sops.secrets."sabnzbd/password".path;
            };

            servers = [
              {
                name = "Eweka";
                host = "sslreader.eweka.nl";
                port = 563;
                username._secret = config.sops.secrets."usenet/eweka/username".path;
                password._secret = config.sops.secrets."usenet/eweka/password".path;
                connections = 20;
                ssl = true;
                priority = 0;
                retention = 3000;
              }

              {
                name = "NewsgroupDirect";
                host = "news.newsgroupdirect.com";
                port = 563;
                username._secret = config.sops.secrets."usenet/newsgroupdirect/username".path;
                password._secret = config.sops.secrets."usenet/newsgroupdirect/password".path;
                connections = 10;
                ssl = true;
                priority = 1;
                optional = true;
                backup = true;
              }
            ];
          };
        };
      };

      jellyfin = {
        enable = true;
        apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
        encoding.hardwareDecodingCodecs = [
          "h264"
          "hevc"
          "mpeg2video"
          "vc1"
          "vp8"
          "vp9"
        ];

        users = {
          henry = {
            mutable = false;
            policy.isAdministrator = true;
            password._secret = config.sops.secrets."jellyfin/henry_password".path;
          };
        };
      };

      seerr = {
        enable = true;
        apiKey._secret = config.sops.secrets."seerr/api_key".path;
      };

      vpn = {
        enable = true;
        wgConfFile = config.sops.secrets."wireguard/conf".path;
        accessibleFrom = ["192.168.68.0/22"];
      };
    };
  };
}
