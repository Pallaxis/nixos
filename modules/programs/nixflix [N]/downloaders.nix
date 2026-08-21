{
  flake.modules.nixos.nixflix = {
    config,
    ...
  }: let
    admin = "henry";
  in {
    nixflix = {
      torrentClients.qbittorrent = {
        enable = true;
        password._secret = config.sops.secrets."qbittorrent/password".path;
        serverConfig = {
          Preferences.WebUI = {
            Username = admin;
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
    };
  };
}
