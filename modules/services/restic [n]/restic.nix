{
  flake.modules.homeManager.restic = {
    config,
    pkgs,
    ...
  }: let
    resticWrapper = pkgs.writeShellScriptBin "restic" ''
      # Wraps restic so i don't need to source a .env file
      export RESTIC_REPOSITORY_FILE="${config.sops.secrets.restic-remote-repo.path}"
      export RESTIC_PASSWORD_FILE="${config.sops.secrets.restic-password.path}"

      exec ${pkgs.restic}/bin/restic "$@"
    '';
  in {
    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/core-key.txt";
      # TODO: ideally this shouldn't be a relative path, or
      # maybe it should always live in the same dir as the sops config file?
      defaultSopsFile = ../../../secrets/core.yaml;
      secrets = {
        # used for wrapper
        restic-remote-repo = {};
        restic-password = {};

        restic-ssh-key = {};
        restic-known-hosts = {};
      };
    };

    programs.ssh = {
      enable = true;

      settings."restic-oracle" = {
        hostname = "137.23.31.130";
        user = "ubuntu";
        identityFile = config.sops.secrets.restic-ssh-key.path;
        identitiesOnly = true;
        userKnownHostsFile = config.sops.secrets.restic-known-hosts.path;
        connectTimeout = 30;
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
      };
    };

    services.restic = {
      enable = true;
      backups = {
        remoteBackup = {
          paths = [config.home.homeDirectory];
          repository = "sftp:restic-oracle:/srv/restic";
          passwordFile = config.sops.secrets.restic-password.path;
          exclude = [
            ".cache/"
            ".local/share/Trash/"
            ".local/share/containers/"
            "downloads/"
            "backup/"
            "git/"
            "work/firmware/"
            "work/burnin/"
            "go/"
          ];
          timerConfig = {
            OnCalendar = "Daily";
            Persistent = true;
          };
          pruneOpts = [
            "--keep-last 10"
          ];
        };
      };
    };

    systemd.user.services."restic-backups-remoteBackup" = {
      Unit = {
        Wants = ["sops-nix.service"];
        After = ["sops-nix.service"];
        OnFailure = [
          "important-unit-failed@%n.service"
        ];
      };
      Service = {
        Restart = "on-failure";
        RestartSec = "5min";
      };
    };

    # TODO: move this somewhere I can reuse it for other services
    systemd.user.services."important-unit-failed@" = {
      Unit = {
        Description = "Notify about failed systemd user unit";
      };

      Service = {
        Type = "oneshot";

        Environment = [
          "FAILED_UNIT=%i"
        ];

        ExecStart = pkgs.writeShellScript "important-unit-failed" ''
          set -eu

          unit="%i"

          ${pkgs.hyprland}/bin/hyprctl notify \
            3 \
            60000 \
            "rgb(ff0000)" \
            "fontsize:30 IMPORTANT: $FAILED_UNIT failed"
        '';
      };
    };
    # TODO: setup a rest server for faster transfers & over https
    # https://github.com/restic/rest-server

    # Extends the generated systemd service to wait for network online
    # may be unneeded, disabling to test
    # systemd.user.services.restic-backups-remoteBackup = {
    #   Unit = {
    #     After = ["network-online.target"];
    #     Wants = ["network-online.target"];
    #   };
    # };

    home.packages = [resticWrapper];
  };
}
