{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix                      # Auto generated hardware file
    ./filesystem.nix                                  # Filesystem stuff that goes with hardware
    ../../modules/core/default.nix                    # Loads all default files all systems should have
    ../../modules/desktop/default.nix                 # Desktop stuff, hyprland etc.
    ../../modules/hardware/nvidia.nix                 # Vendor specific settings
    inputs.home-manager.nixosModules.home-manager
  ];

  # Hostname
  networking.hostName = "night";

  # Temporary
  services.getty.autologinUser = "henry";

  # Home Manager setup
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.henry = import ../../users/henry/home.nix;
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
