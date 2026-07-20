{
  lib,
  config,
  osConfig,
  ...
}: let
  cfg = osConfig.my.restic;
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
  };
}
