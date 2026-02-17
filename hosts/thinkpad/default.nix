{...}: {
  imports = [
    ../../modules
  ];

  my = {
    host = {
      role = "desktop";
      work = true;
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/disk/by-id/nvme-TEAM_TM8FP4512G_17A8079402DE00100982";
        swapSize = "16G";
      };
    };
  };

  home-manager.users.henry = {
    my = {
      home.modules = {
        hyprland = {
          monitor = [
            ",preferred,auto,auto"
            "desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536, 1920x1080@60, 0x0, 1.25" # Work Thinkpad
            "desc:Dell Inc. DELL U2717D 7GGH576A330L, 2560x1440@60, auto-center-up, 1.25"
          ];
          workspaces = [
            "1, monitor:desc:Dell Inc. DELL U2717D 7GGH576A330L, default:true"
            "2, monitor:desc:Dell Inc. DELL U2717D 7GGH576A330L"
            "3, monitor:desc:Dell Inc. DELL U2717D 7GGH576A330L"
            "4, monitor:desc:Dell Inc. DELL U2717D 7GGH576A330L"
            "5, monitor:desc:Dell Inc. DELL U2717D 7GGH576A330L"
            "6, monitor:desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536"
            "7, monitor:desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536"
            "8, monitor:desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536"
            "9, monitor:desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536"
            "10, monitor:desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536, default:true"
          ];
          exec-once = [
            "[workspace 5 silent] slack"
            "[workspace 10 silent] thunderbird"
          ];
        };
      };
    };
  };

  # Only need this on thinkpad
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
  '';

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
