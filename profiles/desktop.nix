{lib, ...}: {
  my = {
    hyprland.enable = lib.mkDefault true;
    networking.enable = lib.mkDefault true;
    plymouth.enable = lib.mkDefault true;
    localsend.enable = lib.mkDefault true;
    thunderbird.enable = lib.mkDefault true;
    catppuccin.enable = lib.mkDefault true;
  };
}
