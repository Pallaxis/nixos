{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.hyprland;
in {
  options.my.home.modules = {
    hyprland = {
      exec-once = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Per host exec-once options to append";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        exec = [
          "hyprctl setcursor Bibata-Modern-Ice 20"
          # FIX: add this to some dconf setting as well as gsettings desktop schemas package
          # dconf.settings = {
          #   "org/gnome/desktop/interface" = {
          #     color-scheme = "prefer-dark";
          #   };
          # };
          # "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
          # "gsettings set org.gnome.desktop.interface cursor-size 20"
        ];
        exec-once = lib.concatLists [
          [
            "[workspace 1 silent] firefox"
            "[workspace 2 silent] foot"
          ]
          (cfg.exec-once or [])
        ];
      };
    };
  };
}
