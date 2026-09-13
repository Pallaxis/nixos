{inputs, ...}: {
  flake.modules.nixos.autoupdate = {
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
      };
    };
  };
}
