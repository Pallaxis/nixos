{lib, ...}: {
  my = {
    workPackages.enable = lib.mkDefault true;
    tio.enable = lib.mkDefault true;
  };
}
