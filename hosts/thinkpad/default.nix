{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix                      # Auto generated hardware file
    ../../modules/core/default.nix                    # Loads all default files all systems should have
    ../../modules/desktop/default.nix                 # Desktop stuff, hyprland etc.
    # ../../modules/apps/other.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Hostname
  networking.hostName = "thinkpad";

  # Temporary
  services.getty.autologinUser = "henry";

  # SSH key
  users.users.root.openssh.authorizedKeys.keys =
  [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTC9Is0+rTNgKa6cs0dR6ZX/IUUU3bHWuV8wzBAHVss"
  ];
  system.stateVersion = "25.11"; # Don't ever change this
}
