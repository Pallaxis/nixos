{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.ssh;
in {
  options.my.home.modules.ssh.enable =
    lib.mkEnableOption "Ssh";

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          addKeysToAgent = "yes";
          setEnv = ["TERM=xterm-256color"];
        };
        "*fenix*.local oclea*.local Oclea*.local zeus*.local hercules*.local depth-rdk*.local" = {
          UserKnownHostsFile = "/dev/null";
          User = "root";
          LogLevel = "QUIET";
          StrictHostKeyChecking = "no";
        };
        "deskpi" = {
          User = "pi";
          Hostname = "deskpi.local";
        };
        "ats*" = {
          User = "pi";
        };
        "ats1" = {
          Hostname = "10.71.7.75";
        };
        "ats2" = {
          Hostname = "10.71.6.220";
        };
        "ats3" = {
          Hostname = "10.71.5.97";
        };
        "mikyla" = {
          User = "mikyla";
          Hostname = "10.71.0.125";
        };
      };
    };
    services = {
      ssh-agent = {
        enable = true;
        socket = "ssh-agent.socket";
      };
    };
  };
}
