{
  osConfig,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = osConfig.my.hyprland;
in {
  imports = [
    ./scripts/brightness.nix
    ./scripts/screenshot-tool.nix
    ./scripts/select-wp.nix
    ./scripts/toggle-workspace-number.nix
    ./scripts/windowpin.nix
  ];
  config = lib.mkIf cfg.enable {
    # my.home.services.handleMonitorConnect.enable = false; # TODO: unneeded systemd service, could keep as an example
    home = {
      # file.".config/hypr/scripts".source = ./scripts;
      pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
        hyprcursor.enable = true;
        hyprcursor.size = 24;
        gtk.enable = true;
      };
    };

    xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        wallpaper = [
          {
            monitor = "";
            path = "${osConfig.my.hyprland.wallpaper}";
          }
        ];
      };
    };
    services.hyprpolkitagent.enable = true;
    services.dunst.enable = true;
    gtk = {
      enable = true;
      colorScheme = "dark";
    };
    qt = {
      enable = true;
      style.name = "kvantum";
      qt5ctSettings = {
        Appearance = {
          style = "kvantum";
          custom_palette = "true";
          color_scheme_path = "/home/${username}/.config/qt5ct/style-colors.conf";
        };
      };
      qt6ctSettings = {
        Appearance = {
          style = "kvantum";
          custom_palette = "true";
          color_scheme_path = "/home/${username}/.config/qt6ct/style-colors.conf";
        };
      };
    };
    programs.quickshell = {
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
    };
    programs.waybar = {
      systemd.enable = true;
      systemd.targets = ["hyprland-session.target"];
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock --grace 0"; # Avoid starting multiple hyprlock instances.
          before_sleep_cmd = "pidof hyprlock || hyprlock --grace 0 --no-fade-in"; # Lock before suspend.
          after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = 'enable' })'"; # To avoid having to press a key twice to turn on the display.
          inhibit_sleep = "2"; # Waits for lock before sleeping
        };

        listener = [
          # After 5 mins
          # Locks session
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }

          # After 10 mins
          # Dims monitors
          # Brightens monitors after activity
          {
            timeout = 600;
            on-timeout = "brightness dim_monitors";
            on-resume = "brightness restore_brightness";
          }

          # After 10 mins
          # Turns off keyboard backlight
          # Turns on keyboard backlight after activity
          {
            timeout = 600;
            on-timeout = "brightnessctl -sd '*':kbd_backlight set 0";
            on-resume = "brightnessctl -rd '*':kbd_backlight";
          }

          # After 30 mins
          # Turns off all monitors
          # Turns on all monitors after activity
          {
            timeout = 1800;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = 'disable' } )'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = 'enable' })'";
          }

          # After 120 mins
          # Suspends system
          {
            timeout = 7200;
            on-timeout = "systemctl suspend";
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
          path = "${osConfig.my.hyprland.wallpaper}";
          blur_passes = "4";
          blur_size = "1";
        };
        label = {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "1%, -1%";
          halign = "left";
          valign = "top";
        };
        input-field = {
          monitor = "";
          size = "300, 60";
          outline_thickness = "4";
          dots_size = "0.2";
          dots_spacing = "0.2";
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$subtext0";
          font_family = "JetBrainsMono Nerd Font";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$subtext0Alpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
