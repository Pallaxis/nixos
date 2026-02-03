{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/default.nix # Desktop stuff, hyprland etc.
    ./disk-config.nix
    # ../../modules/apps/other.nix
  ];
  desktop.hyprland.enable = true;

  # Hostname
  networking.hostName = "thinkpad";

  system.stateVersion = "25.11"; # Don't ever change this
}
