{ pkgs, ... }:

{
  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  services.hypridle.enable = pkgs.stdenv.isLinux;
  services.hyprpaper = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      splash = false;
      preload = [ "${../wallpapers/kcd2-hawk-two-horses.png}" ];
      wallpaper = [
        {
          monitor = "";
          path = "${../wallpapers/kcd2-hawk-two-horses.png}";
        }
      ];
    };
  };
  services.hyprpolkitagent.enable = pkgs.stdenv.isLinux;
}
