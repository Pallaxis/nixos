{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
    ../../modules/core/default.nix
    ../../modules/desktop/default.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "night";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.henry = import ../../users/henry/home.nix;
  };

  services.getty.autologinUser = "henry";
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  ### BOOT ###
  system.stateVersion = "25.11"; # Don't ever change this
}
