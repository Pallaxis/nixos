{lib, ...}: {
  options.my.waybar.enable =
    lib.mkEnableOption "Waybar";
}
