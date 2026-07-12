{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.diagnostics;
in {
  options.my.diagnostics.enable =
    lib.mkEnableOption "Enables diagnostic tools";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nethogs
      tcpdump
      nmap
    ];
  };
}
