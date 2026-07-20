{lib, ...}: {
  my = {
    catppuccin.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    localsend.enable = lib.mkDefault true;
    plymouth.enable = lib.mkDefault true;
    restic.enable = lib.mkDefault true;
    thunderbird.enable = lib.mkDefault true;
  };
}
