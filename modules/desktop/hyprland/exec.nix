{ ... }:
  {
  home-manager.users.henry = {
    wayland.windowManager.hyprland = {
      settings = {
        exec = [
          "hyprctl setcursor Bibata-Modern-Ice 20"
          "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
          "gsettings set org.gnome.desktop.interface cursor-size 20"
        ];
        exec-once = [
          "[workspace 1 silent] firefox"
          "[workspace 2 silent] foot"
          "waybar"
          "hypridle											# Start idle management daemon"
          "hyprpaper											# Start idle management daemon"
          "~/.config/hypr/scripts/handle_monitor_connect.sh"
        ];
      };
    };
  };
}
