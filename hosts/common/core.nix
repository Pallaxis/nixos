{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
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
  #  "resume=/dev/mapper/nixos-root"
    "resume_offset=533760"
  ];
  zramSwap.enable = false;
  # To fix device not shutting off after hibernating
  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';
  # found with google ai search
  powerManagement.enable = true;

  networking.hostName = "night"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  services.getty.autologinUser = "henry";
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.henry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    home = "/home/henry";
    shell = pkgs.zsh;
  #  packages = with pkgs; [
  #    tree
  #  ];
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  # programs.foot = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   settings = {
  #     main = {
  #       font = "JetbrainsMonoNerd:size11";
  #     };
  #   };
  # };
  programs.neovim.enable = true;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    btop
    cowsay
    dunst
    eza
    fastfetch
    flatpak
    fortune
    fd
    grimblast
    foot
    fzf
    tmux
    git
    waybar
    rofi
    keepassxc
    udisks
    tldr
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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
  # fix to get trackpad to notice when I'm typing
  environment.etc."libinput/local-overrides.quirks".text = pkgs.lib.mkForce ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
    MatchName=keyd virtual keyboard
    '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
