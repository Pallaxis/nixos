{inputs, ...}: let
  username = "henry";
in {
  flake.modules.homeManager."${username}" = {
    config,
    lib,
    osConfig,
    ...
  }: {
    imports = with inputs.self.modules.homeManager; [
      syncthing
    ];
    services.syncthing.settings = {
      folders = {
        "Syncthing" = {
          id = "syncthing";
          path = "${config.home.homeDirectory}/share/Syncthing";

          # Adds all known devices to this list, except current hostname
          # relies on the hostname being the same as the syncthing device name
          devices =
            lib.remove
            osConfig.networking.hostName
            (lib.attrNames config.services.syncthing.settings.devices);

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
    # Ensures the file actually exists for syncthing to setup
    home.activation.createSyncthingDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "${config.home.homeDirectory}/share/Syncthing"
    '';
  };
}
