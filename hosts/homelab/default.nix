{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules
    ../../profiles/core.nix
  ];

  # Global options
  my = {
    host = {
      role = "desktop";
    };
    modules = {
      disko = {
        enable = true;
        bootDisk = "/dev/nvme0n1";
        swapSize = "8G";
      };
    };
    ssh.enable = true;
    ssh.server.enable = true;
    nixflix.enable = true;
  };

  # TODO: remove me, for testing purposes
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.11"; # Don't ever change this
}
