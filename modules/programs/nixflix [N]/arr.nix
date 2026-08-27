{
  flake.modules.nixos.nixflix = {config, ...}: let
    admin = "henry";
  in {
    nixflix = {
      sonarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."sonarr/api_key".path;
          hostConfig = {
            username = admin;
            password._secret = config.sops.secrets."sonarr/password".path;
          };
        };
      };

      radarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."radarr/api_key".path;
          hostConfig = {
            username = admin;
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
            username = admin;
            password._secret = config.sops.secrets."lidarr/password".path;
          };
        };
      };

      prowlarr = {
        enable = true;
        config = {
          apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
          hostConfig = {
            username = admin;
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
    };
  };
}
