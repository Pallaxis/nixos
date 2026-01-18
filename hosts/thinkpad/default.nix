{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/default.nix
    ../../modules/desktop/default.nix
    inputs.home-manager.nixosModules.home-manager
  ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.henry = import ../../users/henry/home.nix;
    };

  networking.hostName = "thinkpad"; # Define your hostname.
  services.getty.autologinUser = "henry";
  users.users.henry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/henry";
    shell = pkgs.zsh;
  };



  ### SERVICES ###
  services.xserver.xkb.layout = "us";
  # fix to get trackpad to notice when I'm typing
  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
    MatchName=keyd virtual keyboard
  '';

  system.stateVersion = "25.11"; # Don't ever change this
}
