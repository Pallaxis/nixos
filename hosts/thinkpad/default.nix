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
  apps.others.enable = true;

  # Hostname
  networking.hostName = "thinkpad";

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
  '';

  services.keyd = {
    keyboards.caps-swap.settings = {
      main = {
        sysrq = "layer(meta)";
      };
    };
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
