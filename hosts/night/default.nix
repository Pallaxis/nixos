{lib, ...}: {
  imports = [
    ../../modules
  ];

  my = {
    host = {
      role = "desktop";
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/disk/by-id/nvme-eui.00000000000000000026b768622a1055";
        swapSize = "32G";
      };
      gaming.enable = true;
      others.enable = true;
    };
  };
  home-manager.users.henry = {
    my = {
      home.modules = {
        hyprland = {
          monitor = [
            ",preferred,auto,auto"
            "desc:Samsung Electric Company LC32G7xT H4ZR900653, 2560x1440@240, 0x0, 1"
            "desc:Ancor Communications Inc ROG PG278Q, 2560x1440@144, -2560x0, 1"
            # "DP-1, 2560x1440@144, -2560x0, 1"
          ];
        };
      };
    };
  };

  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];

  system.stateVersion = "25.11"; # Don't ever change this
}
