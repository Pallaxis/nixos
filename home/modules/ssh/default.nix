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
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "*fenix*.local oclea*.local Oclea*.local zeus*.local hercules*.local depth-rdk*.local" = {
          userKnownHostsFile = "/dev/null";
          user = "root";
          extraOptions = {
            LogLevel = "QUIET";
            StrictHostKeyChecking = "no";
          };
        };
        "deskpi" = {
          user = "pi";
          hostname = "deskpi.local";
        };
        "ats*" = {
          user = "pi";
        };
        "ats1" = {
          hostname = "10.71.7.75";
        };
        "ats2" = {
          hostname = "10.71.7.72";
        };
        "ats4" = {
          hostname = "10.71.5.97";
        };
        "mikyla" = {
          user = "mikyla";
          hostname = "10.71.0.125";
        };
      };
    };
    services = {
      ssh-agent = {
        enable = true;
        socket = "ssh-agent.socket";
        enableZshIntegration = true;
      };
    };
  };
}
