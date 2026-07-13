{
  lib,
  config,
  ...
}: let
  cfg = config.my.ssh;
  cfgServer = config.my.ssh.server;
in {
  options.my.ssh = {
    enable = lib.mkEnableOption "SSH";
    server.enable = lib.mkEnableOption "SSHD server";
  };
  config = lib.mkIf cfg.enable {
    services.openssh.enable = lib.mkIf cfgServer.enable true; # only turn on sshd for servers
  };
}
