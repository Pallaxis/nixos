{
  flake.modules.nixos.autoupdate = {
    pkgs,
    lib,
    ...
  }: let
    repoPath = "/home/henry/.nixos";
    branch = "main";

    # Notify the logged-in user. Falls back to a no-op when no desktop session bus is available.
    notifyUpgrade = pkgs.writeShellApplication {
      name = "notify-upgrade";
      runtimeInputs = with pkgs; [coreutils libnotify util-linux];
      text = ''
        msg="''${1:-A system update is underway}"
        for bus in /run/user/*/bus; do
          [ -S "$bus" ] || continue
          uid=''${bus#/run/user/}
          uid=''${uid%%/*}
          runuser -u "$uid" -- \
            env DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" XDG_RUNTIME_DIR="''${bus%/bus}" \
            timeout 10 notify-send -a nixos-upgrade "System update" "$msg" \
            > /dev/null 2>&1
        done
        exit 0
      '';
    };

    # Upgrade-time guard: only act when the local checkout is clean AND has no local commits
    # (nothing unpushed). When in this state, it's safe to fast-forward/pull from origin
    # if behind; we never overwrite local work. Otherwise skip and notify with the reason.
    gitPullSafe = pkgs.writeShellApplication {
      name = "git-pull-safe";
      runtimeInputs = with pkgs; [git systemd coreutils gnugrep util-linux];
      text = ''
        set -euo pipefail
        cd ${repoPath}
        git fetch origin "+refs/heads/${branch}:refs/remotes/origin/${branch}"

        skip_msg=""
        if ! git diff --quiet || ! git diff --cached --quiet; then
          skip_msg="Skipped auto-update: uncommitted changes in ${repoPath}"
        elif ! git merge-base --is-ancestor HEAD "refs/remotes/origin/${branch}"; then
          skip_msg="Skipped auto-update: unpushed local commits on ${branch} in ${repoPath}"
        fi

        if [ -n "$skip_msg" ]; then
          ${notifyUpgrade}/bin/notify-upgrade "$skip_msg"
          exit 0
        fi

        if git diff --quiet HEAD "refs/remotes/origin/${branch}"; then
          exit 0
        fi

        git reset --hard "refs/remotes/origin/${branch}"
        systemctl start nixos-upgrade
      '';
    };
  in {
    programs.git.enable = true;
    programs.git.config.safe.directory = repoPath;

    # update system from the local checkout, gated by git-pull-safe.
    # builds exactly what's on disk, so it can never omit local commits.
    system.autoUpgrade = {
      enable = true;
      flake = repoPath;
    };

    # the built-in timer is unused; git-pull-safe triggers nixos-upgrade instead.
    systemd.timers.nixos-upgrade.wantedBy = lib.mkForce [];

    systemd.services.git-pull-safe = {
      description = "Fetch+reset nixos repo and trigger nixos-upgrade when safe";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${gitPullSafe}/bin/git-pull-safe";
      };
    };

    systemd.timers.git-pull-safe = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "45m";
        Persistent = true;
      };
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
          "${notifyUpgrade}/bin/notify-upgrade"
        ];
      };
    };
  };
}
