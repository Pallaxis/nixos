# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ../../modules/core/default.nix
    # ../../modules/desktop/
    inputs.home-manager.nixosModules.home-manager
  ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.henry = import ../../users/henry/home.nix;
    };

  ### BOOT ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices = {
    nixos-root = {
      device = "/dev/disk/by-uuid/daf4fdf1-dbf2-45d6-993a-75bd9636f471";
      preLVM = true;
    };
  };
  fileSystems."/" = {
    device = "/dev/mapper/nixos-root";
    fsType = "btrfs";
  };
  swapDevices = [{
    device = "/.swapvol/swapfile";
  }];
  # For hibernate resume, offset to swap offset
  boot.resumeDevice = "/dev/mapper/nixos-root";
  boot.kernelParams = [
    "resume_offset=533760"
  ];
  # To fix device not shutting off after hibernating, may remove if unneeded
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';

  networking.hostName = "night"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;


  ### USERS ###
  users.users.henry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/henry";
    shell = pkgs.zsh;
  };


  ### SYSTEM PROGRAMS ###
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.neovim.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    dunst
    flatpak
    fd
    grimblast
    fzf
    git
    waybar
    rofi
    udisks
    file
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  ### SERVICES ###
  services.xserver.xkb.layout = "us";
  services.getty.autologinUser = "henry";
  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.udisks2.enable = true;
  services.keyd = {
    enable = true;
    keyboards.caps-swap.settings = {
      main = {
        capslock = "esc";
        esc = "capslock";
      };
    };
  };


  ### SYSTEM CONFIGS ###
  # fix to get trackpad to notice when I'm typing
  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
    MatchName=keyd virtual keyboard
  '';
  
  # sudo password timeout
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=15
  '';

  system.stateVersion = "25.11"; # Don't ever change this
}
