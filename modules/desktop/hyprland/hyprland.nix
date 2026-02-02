{
  config,
  lib,
  pkgs,
  host,
  ...
}: let
  # Pulls each var out I've listed to use in this file
  inherit
    (import ../../../hosts/${host}/system-vars.nix)
    wallpaper
    monitor_config
    ;
in {
  options.desktop.hyprland = {
    enable = lib.mkEnableOption "Enables Hyprland";
  };
  config = lib.mkIf config.desktop.hyprland.enable {
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
          monitor = monitor_config;
        };
      };
      services.hyprpaper = {
        enable = true;
        settings = {
          splash = false;
          # Coerces path to string
          preload = ["${wallpaper}"];
          wallpaper = [
            {
              monitor = "";
              path = "${wallpaper}";
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
