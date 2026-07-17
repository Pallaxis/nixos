{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../profiles/core.nix
    ../../profiles/desktop.nix
  ];

  # Global options
  my = {
    host = {
      role = "desktop";
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/disk/by-id/wwn-0x5001b44a8a722190";
        swapSize = "8G";
      };
    };
  };

  # Needed for stupid broadcom-wl driver
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.18.38"
  ];
  boot = {
    kernelModules = ["kvm-intel" "wl"];
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
