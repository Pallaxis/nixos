{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/desktop/default.nix                 # Desktop stuff, hyprland etc.
    ../../modules/hardware/nvidia.nix                 # Vendor specific settings
    ../../modules/apps/other.nix
    ../../modules/apps/gaming.nix
  ];

  # Hostname
  networking.hostName = "night";
  # Temporary
  services.getty.autologinUser = "henry";

  # Swap file
  swapDevices = lib.mkForce [{
    device = "/.swapvol/swapfile";
  }];

  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];

  system.stateVersion = "25.11"; # Don't ever change this
}
