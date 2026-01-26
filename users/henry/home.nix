{pkgs, ...}: {
  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "25.11";
  };

  imports = [
    ./modules/shell.nix
    ./modules/env.nix
    ./modules/nvim/nvim.nix
  ];
  ### LAZY DOTFILES ###
  home.file.".config/waybar".source = ./dotfiles/waybar;
  home.file.".config/bat".source = ./dotfiles/bat;
  home.file.".config/foot".source = ./dotfiles/foot;
  home.file.".config/rofi".source = ./dotfiles/rofi;
  home.file.".zshrc".source = ./dotfiles/.zshrc;
  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;

  ### USER SERVICES ###
  services.ssh-agent = {
    enable = true;
    socket = "ssh-agent.socket";
    enableZshIntegration = true;
  };

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
}
