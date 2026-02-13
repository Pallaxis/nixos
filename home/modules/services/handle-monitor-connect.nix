{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.services.handleMonitorConnect;
in {
  options.my.home.services.handleMonitorConnect.enable =
    lib.mkEnableOption "Hypland monitor handler, triggered on new monitor detected";

  config = lib.mkIf cfg.enable {
    systemd.user.services."handle-monitor-connect" = {
      Unit = {
        Description = "Moves workspaces when new monitor is connected";
        After = ["graphical-session.target"];
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        Restart = "on-failure";
        ExecStart = "${pkgs.writeShellApplication {
          name = "handle-monitor-connect";
          runtimeInputs = [pkgs.socat pkgs.hyprland pkgs.coreutils];

          text = ''
            handle() {
              case "$1" in
                monitoradded*)
                  seq 1 5 | xargs -I {} hyprctl dispatch moveworkspacetomonitor {} 1
                  ;;
              esac
            }

            hypr_socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
            socat -u UNIX-CONNECT:"$hypr_socket" - |
            while read -r line; do
              # echo "handling $line"
              handle "$line"
            done

            echo "Outside of loop, something's gone wrong!"
            exit 1
          '';
        }}/bin/handle-monitor-connect";
      };
    };
  };
}
