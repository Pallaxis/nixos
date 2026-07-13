{...}: {
  imports = [
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
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
