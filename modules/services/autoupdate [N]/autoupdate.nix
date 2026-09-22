{inputs, ...}: {
  flake.modules.nixos.autoupdate = {pkgs, ...}: {
    # auto updates system from github repo
    # as long as current generation is clean
    system.autoUpgrade = {
      enable = builtins.match ".*-dirty$" (inputs.self.rev or inputs.self.dirtyRev) == null;
      flake = "github:pallaxis/nixos/main";
      randomizedDelaySec = "45m";
    };
    systemd.services.nixos-upgrade = {
      after = ["network-online.target"];
      wants = ["network-online.target"];
      startLimitIntervalSec = 120;
      startLimitBurst = 6;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "20";
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ExecStartPre = [
          "${(pkgs.writeShellApplication {
            name = "notify-upgrade";
            runtimeInputs = with pkgs; [coreutils libnotify util-linux];
            text = ''
              # Notify the logged-in user that a system update is underway.
              # Falls back to a no-op when no desktop session bus is available.
              for bus in /run/user/*/bus; do
                [ -S "$bus" ] || continue
                uid=''${bus#/run/user/}
                uid=''${uid%%/*}
                runuser -u "$uid" -- \
                  env DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" XDG_RUNTIME_DIR="''${bus%/bus}" \
                  timeout 10 notify-send -a nixos-upgrade "System update" "A system update is underway" \
                  > /dev/null 2>&1 &
              done
              exit 0
            '';
          })}/bin/notify-upgrade"
        ];
      };
    };
  };
}
