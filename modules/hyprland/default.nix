{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.hyprland;
in {
  options.my.modules.hyprland.enable =
    lib.mkEnableOption "Hyprland";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.systemd}/bin/systemd-cat ${config.programs.hyprland.package}/bin/start-hyprland";
          user = "henry";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd ${pkgs.systemd}/bin/systemd-cat ${config.programs.hyprland.package}/bin/start-hyprland";
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
