{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.hyprland;
in {
  options.my.modules = {
    hyprland = {
      enable = lib.mkEnableOption "hyprland";
    };
  };
  config = lib.mkIf cfg.enable {
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
  };
}
