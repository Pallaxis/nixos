{lib, ...}: {
  options.my.syncthing.enable =
    lib.mkEnableOption "Syncthing";
}
