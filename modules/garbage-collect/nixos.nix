{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.garbageCollect;
in {
  options.my.garbageCollect.enable =
    lib.mkEnableOption "GarbageCollect";

  config = lib.mkIf cfg.enable {
    systemd.services."nix-env-delete-generations" = {
      description = "Dereferences all but the last 5 nixos generations";
      path = [pkgs.nix pkgs.bash];
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.bash}/bin/bash -c 'nix-env --profile /nix/var/nix/profiles/system --delete-generations +5 && nix-collect-garbage'";
      };
    };
    systemd.timers."nix-env-delete-generations" = {
      description = "Daily timer for nix-env garbage collection";
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
      wantedBy = ["timers.target"];
    };
  };
}
