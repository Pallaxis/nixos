{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.syncthing;
in {
  options.my.home.modules.syncthing.enable =
    lib.mkEnableOption "Syncthing";

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        settings = {
          devices = {
            iPhone = {
              addresses = [
                "automatic"
              ];
              id = "UBH4QQR-EFVPO6H-TJTENLD-K7PSSAS-34KPRWJ-MNJ2CQY-65H3IN7-4633XAQ";
            };
          };
          folders = {
            "/home/henry/share/Syncthing" = {
              id = "syncthing";
              devices = ["iPhone"];
              versioning = {
                type = "simple";
                params = {
                  keep = "10";
                  cleanInterval = "3600";
                };
              };
            };
          };
        };
      };
    };
  };
}
