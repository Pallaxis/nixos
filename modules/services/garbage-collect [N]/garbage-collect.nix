let
  keepGenerations = 20;
in {
  flake.modules.nixos.garbageCollect = {pkgs, ...}: {
    systemd.services.prune-nixos-generations = {
      description = "Prune old NixOS generations, keeping up to ${toString keepGenerations} and garbage collect";
      serviceConfig = {
        User = "root";
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "prune-nixos-generations" ''
          ${pkgs.nix}/bin/nix-env \
            --profile /nix/var/nix/profiles/system \
            --delete-generations +${toString keepGenerations}

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
