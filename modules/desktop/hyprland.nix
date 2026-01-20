{ config, lib, ... }:

  {
  options.myOptions.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "Path to wallpaper image, set in the hosts default.nix";
  };
  config = {
    programs.hyprland.enable = true;

    home-manager.users.henry = {
      wayland.windowManager.hyprland = {
        enable = true;
      };
      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          preload = [ "${config.myOptions.wallpaper}" ];
          wallpaper = [
            {
              monitor = "";
              path = "${config.myOptions.wallpaper}";
            }
          ];
        };
      };
      services.hypridle.enable = true;
      services.hyprpolkitagent.enable = true;
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
    };
  };
}
