{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.hyprland;
in {
  options.my.home.modules = {
    hyprland = {
      enable = lib.mkEnableOption "hyprland";
      monitor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ",preferred,auto,auto"
        ];
        description = "Hyprland monitors";
      };
    };
    hyprpaper = {
      path = lib.mkOption {
        type = lib.types.path;
        default = ./wallpapers/forrest.png;
        description = "Wallpaper used by hyprpaper";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/hypr/scripts".source = ./scripts;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        monitor = [
          config.my.home.modules.hyprland.monitor
        ];
      };
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = toString config.my.home.modules.hyprpaper.path;
          }
        ];
      };
    };
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
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock --grace 0"; # Avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # Lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # To avoid having to press a key twice to turn on the display.
          inhibit_sleep = "3"; # Waits for lock before sleeping
        };

        listener = [
          {
            timeout = 300; # 5 mins.
            on-timeout = "$XDG_CONFIG_HOME/hypr/scripts/brightness.sh dim_monitors"; # Set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "$XDG_CONFIG_HOME/hypr/scripts/brightness.sh restore_brightness"; # Monitor backlight restore.
          }
          # turn off keyboard backlight
          {
            timeout = 300; # 5 mins.
            on-timeout = "brightnessctl -sd '*':kbd_backlight set 0"; # Turn off keyboard backlight.
            on-resume = "brightnessctl -rd '*':kbd_backlight"; # Turn on keyboard backlight.
          }
          {
            timeout = 300; # 5 mins
            on-timeout = "loginctl lock-session"; # Lock screen when timeout has passed
          }
          {
            timeout = 900; # 15min
            on-timeout = "hyprctl dispatch dpms off"; # Screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # Screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 7200; # 120min
            on-timeout = "systemctl suspend"; # Suspend pc
          }
        ];
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          immediate_render = true;
          ignore_empty_input = true;
        };
        background = {
          monitor = "";
          path = toString config.my.home.modules.hyprpaper.path;
          blur_passes = "4";
          blur_size = "1";
        };
        label = {
          monitor = "";
          text = "$TIME";
          font_size = 90;
          font_family = "JetBrainsMono Nerd Font";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        };

        input-field = {
          monitor = "";
          size = "300, 60";
          outline_thickness = "4";
          dots_size = "0.2";
          dots_spacing = "0.2";
          dots_center = true;
          font_color = "$text";
          font_family = "$font";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };
    catppuccin.hyprlock = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
      useDefaultConfig = false;
    };
  };
}
