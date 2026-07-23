{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  cfg = osConfig.my.restic;
  resticWrapper = pkgs.writeShellScriptBin "restic" ''
    # Wraps restic so i don't need to source a .env file
    export RESTIC_REPOSITORY_FILE="${config.sops.secrets.restic-remote-repo.path}"
    export RESTIC_PASSWORD_FILE="${config.sops.secrets.restic-password.path}"

    exec ${pkgs.restic}/bin/restic "$@"
  '';
in {
  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      defaultSopsFile = ../../secrets/core.yaml;
      secrets = {
        restic-remote-repo = {};
        restic-password = {};
        restic-ssh-key = {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519_oracle";
          mode = "0600";
        };
        restic-known-hosts = {
          # TODO: use this to avoid needing to ssh to the server first time
          path = "${config.xdg.configHome}/restic/known-hosts";
          mode = "0600";
        };
      };
    };
    services.restic = {
      enable = true;
      backups = {
        remoteBackup = {
          paths = [config.home.homeDirectory];
          repositoryFile = config.sops.secrets.restic-remote-repo.path;
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
            "go"
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
