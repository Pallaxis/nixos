{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.scripts.handleMonitorConnect;
  myScript = pkgs.writeShellApplication {
    name = "handle-monitor-connect";
    runtimeInputs = [pkgs.socat pkgs.hyprland pkgs.coreutils];

    text = ''
      #!/usr/bin/env bash
      handle() {
        case "$1" in
          monitoradded*)
            seq 1 5 | xargs -I {} hyprctl dispatch moveworkspacetomonitor {} 1
            ;;
        esac
      }

      socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
        | while read -r line; do
            handle "$line"
          done
    '';
  };
in {
  options.my.home.scripts.handleMonitorConnect.enable =
    lib.mkEnableOption "Hypland monitor handler, triggered on new monitor detected";

  config = lib.mkIf cfg.enable {
    home.packages = [myScript];
  };
}
