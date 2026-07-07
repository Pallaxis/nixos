{lib, ...}: {
  my = {
    garbageCollect.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault true;
    terminal.enable = lib.mkDefault true;
  };
}
