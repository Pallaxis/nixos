{ config, pkgs, ... }:

{
  home.username = "henry";
  home.homeDirectory = "/home/henry";
  home.stateVersion = "25.11";

  imports = [
    ./modules/shell.nix
    ./modules/linux.nix
  ];
  ### LAZY DOTFILES ###
  home.file.".config/nvim".source = ./dotfiles/nvim;
  home.file.".config/waybar".source = ./dotfiles/waybar;
  home.file.".config/bat".source = ./dotfiles/bat;
  home.file.".config/foot".source = ./dotfiles/foot;
  home.file.".config/rofi".source = ./dotfiles/rofi;
  home.file.".zshrc".source = ./dotfiles/.zshrc;
  # home.file.".local/share/wallpapers".source = ./wallpapers;

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;

  
  ### USER SERVICES ###
  services.ssh-agent = {
    enable = true;
    socket = "ssh-agent.socket";
    enableZshIntegration = true;
  };
  # wayland.windowManager.hyprland.systemd.variables = ["--all"];

  home.packages = with pkgs; [
    bat
    btop
    cowsay
    eza
    fastfetch
    foot
    fortune
    fzf
    gcc
    git
    keepassxc
    lolcat
    nerd-fonts.jetbrains-mono
    tldr
    tmux
  ];


  ### USER PROGRAMS ###
  # programs.zsh.enable = true;
}
