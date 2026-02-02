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
  services = {
    ssh-agent = {
      enable = true;
      socket = "ssh-agent.socket";
      enableZshIntegration = true;
    };
    syncthing = {
      enable = true;
      settings = {
        devices = {
          iPhone = {
            addresses = [
              "automatic"
            ];
            id = "UBH4QQR-EFVPO6H-TJTENLD-K7PSSAS-34KPRWJ-MNJ2CQY-65H3IN7-4633XAQ";
          };
        };
        folders = {
          "/home/henry/share/Syncthing" = {
            id = "syncthing";
            devices = ["iPhone"];
            versioning = {
              type = "simple";
              params = {
                keep = "10";
                cleanInterval = "3600";
              };
            };
          };
        };
      };
    };
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
