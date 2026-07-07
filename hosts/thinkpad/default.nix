{...}: {
  imports = [
    ../../modules
    ../../profiles/core.nix
    ../../profiles/desktop.nix
    ../../profiles/workstation.nix
  ];

  # Global options
  my = {
    host = {
      role = "desktop";
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/disk/by-id/nvme-TEAM_TM8FP4512G_17A8079402DE00100982";
        swapSize = "16G";
      };
    };
  };

  # Only need this on thinkpad
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
  '';

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "powereoff";
  };

  # Unique to thinkpad, PrtSc button where meta key should be
  services.keyd = {
    keyboards.caps-swap.settings = {
      main = {
        sysrq = "layer(meta)";
      };
    };
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
