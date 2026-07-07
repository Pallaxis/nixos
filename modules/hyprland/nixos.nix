{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.my.hyprland;
in {
  options = {
    my.hyprland = {
      enable = lib.mkEnableOption "Hyprland";
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = ./wallpapers/forrest.png;
        description = "Wallpaper used by hyprpaper";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    my.waybar.enable = false;
    my.quickshell.enable = true;
    my.desktop.enable = true;

    programs.hyprland = {
      enable = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.systemd}/bin/systemd-cat -t hyprland ${config.programs.hyprland.package}/bin/start-hyprland";
          user = username;
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd \"${pkgs.systemd}/bin/systemd-cat -t hyprland ${config.programs.hyprland.package}/bin/start-hyprland\"";
          user = "greeter";
        };
      };
    };
    environment.systemPackages = with pkgs; [
      tuigreet
      bibata-cursors
    ];
  };
}
