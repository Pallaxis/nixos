{ config, lib, pkgs, ... }:

{
  options.myOptions.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "Path to wallpaper image, set in the hosts default.nix";
  };

  config = {
    ### GLOBAL ###
    programs.hyprland = {
      enable = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "start-hyprland";
          user = "henry";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd start-hyprland";
          user = "greeter";
        };
      };
    };
    environment.systemPackages = with pkgs; [
      tuigreet
      bibata-cursors
    ];

    #$hypr_scr_path = ~/.config/hypr/scripts
    ### HOME MANAGED ###
    home-manager.users.henry = {
      home.file.".config/hypr/scripts".source = ../../../users/henry/dotfiles/hypr/scripts;
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        settings = {
          monitor = [
            ",preferred,auto,auto"
            "desc:Samsung Electric Company LC32G7xT H4ZR900653, 2560x1440@240, 0x0, 1"
            "desc:Ancor Communications Inc ROG PG278Q, 2560x1440@144, -2560x0, 1"
            "DP-1, 2560x1440@144, -2560x0, 1"
          ];
        };
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
      gtk = {
        enable = true;
        cursorTheme = {
          name = "Bibata-Modern_Ice";
          package = pkgs.bibata-cursors;
        };
      };
      programs.waybar = {
        enable = true;
      };
    };
  };
}
