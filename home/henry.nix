{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./modules
  ];

  my.home.modules =
    {
      ssh.enable = true;
      thunderbird.enable = true;
    }
    // lib.optionalAttrs osConfig.my.modules.gaming.enable {
      lutris.enable = true;
    }
    // lib.optionalAttrs (osConfig.my.host.name == "thinkpad") {
    };
  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "mocha";

    hyprlock.useDefaultConfig = false;
    zsh-syntax-highlighting.enable = false;
    thunderbird.profile = "henry";
    tmux.extraConfig = ''
      set -g @catppuccin_window_status_style "rounded"
      set -ogq @catppuccin_window_text " #W"
      set -ogq @catppuccin_window_current_text " #W"
      set -g status-left ""
      set -g status-right "#{?window_zoomed_flag,#[fg=#{@thm_mauve}]ZOOMED ,}#{E:@catppuccin_status_session}"
    '';
  };
  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "26.05";
  };

  ### LAZY DOTFILES ###
  home.file.".config/rofi".source = ./dotfiles/rofi;

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;

  ### USER SERVICES ###
  services = {
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
    cowsay
    fastfetch
    foot
    fortune
    gcc
    keepassxc
    lolcat
    nerd-fonts.jetbrains-mono
    ripgrep
    tmux
  ];
}
