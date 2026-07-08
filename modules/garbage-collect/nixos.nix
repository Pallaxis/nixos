{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.garbageCollect;
in {
  options.my.garbageCollect = {
    enable = lib.mkEnableOption "automatic Nix garbage collection";

    keepGenerations = lib.mkOption {
      type = lib.types.ints.between 2 100;
      default = 20;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.prune-nixos-generations = {
      description = "Prune old NixOS generations, keeping up to ${toString cfg.keepGenerations} and garbage collect";
      serviceConfig = {
        User = "root";
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "prune-nixos-generations" ''
          ${pkgs.nix}/bin/nix-env \
            --profile /nix/var/nix/profiles/system \
            --delete-generations +${toString cfg.keepGenerations}

          ${pkgs.nix}/bin/nix-collect-garbage
        '';
      };
    };

    systemd.timers.prune-nixos-generations = {
      wantedBy = ["timers.target"];

      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };
}
