{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/default.nix
    ./disk-config.nix
  ];
  desktop.hyprland.enable = true;
  apps.work.enable = true;

  # Hostname
  networking.hostName = "thinkpad";

  system.stateVersion = "25.11"; # Don't ever change this
}
