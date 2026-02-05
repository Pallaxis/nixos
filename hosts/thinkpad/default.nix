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

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
  '';

  system.stateVersion = "25.11"; # Don't ever change this
}
