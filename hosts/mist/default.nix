{...}: {
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
  system.stateVersion = "25.11"; # Don't ever change this
}
