{
  osConfig,
  lib,
  username,
  ...
}: let
  cfg = osConfig.my.syncthing;
in {
  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        settings = {
          devices = {
            iPhone = {
              addresses = ["dynamic"];
              id = "UBH4QQR-EFVPO6H-TJTENLD-K7PSSAS-34KPRWJ-MNJ2CQY-65H3IN7-4633XAQ";
            };
            mist = {
              addresses = ["dynamic"];
              id = "MCUYRFM-TSVNHCD-AXV45IH-3I7Z3D6-HKPP2BY-32IG4SS-WFHEPFT-VFEXEQ6";
            };
            homeserver = {
              addresses = ["dynamic"];
              id = "4ENPKBG-HANSDQP-I4CC4XX-IVPRRNT-5CQ266C-VCLLK65-3RLAXNQ-Q5TT5AD";
            };
          };
          folders = {
            "/home/${username}/share/Syncthing" = {
              id = "syncthing";
              devices = ["iPhone" "mist" "homeserver"];
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
