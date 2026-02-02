{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/desktop/default.nix                 # Desktop stuff, hyprland etc.
    # ../../modules/apps/other.nix
  ];

  # Hostname
  networking.hostName = "thinkpad";

  system.stateVersion = "25.11"; # Don't ever change this
}
