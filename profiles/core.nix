{lib, ...}: {
  my = {
    diagnostics.enable = lib.mkDefault true;
    garbageCollect.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault true;
    terminal.enable = lib.mkDefault true;
  };
}
