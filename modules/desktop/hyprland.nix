{ config, lib, pkgs, ... }:

  {
  options.myOptions.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "Path to wallpaper image, set in the hosts default.nix";
  };

  config = {
    ### GLOBAL ###
    programs.uwsm = { enable = true; };
    programs.hyprland = {
      enable = true;
    };
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     initial_session = {
    #       command = "uwsm start hyprland-uwsm.desktop";
    #       user = "henry";
    #     };
    #     default_session = {
    #       command = "${pkgs.tuigreet}/bin/tuigreet --cmd 'exec uwsm start hyprland-uwsm.desktop'";
    #       user = "greeter";
    #     };
    #   };
    # };
    # environment.systemPackages = with pkgs; [
    #   tuigreet
    # ];

    ### HOME MANAGED ###
    home-manager.users.henry = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
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
      };
    };
  };
}
