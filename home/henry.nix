{pkgs, ...}: {
  imports = [
    ./modules
  ];

  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "25.11";
  };

  my = {
    home = {
      modules = {
        hyprland.enable = true;
        lutris.enable = true;
      };
      services = {
        handleMonitorConnect.enable = true;
      };
    };
  };

  ### LAZY DOTFILES ###
  home.file.".config/waybar".source = ./dotfiles/waybar;
  home.file.".config/bat".source = ./dotfiles/bat;
  home.file.".config/foot".source = ./dotfiles/foot;
  home.file.".config/rofi".source = ./dotfiles/rofi;

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
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "*fenix*.local oclea*.local Oclea*.local zeus*.local hercules*.local depth-rdk*.local" = {
        userKnownHostsFile = "/dev/null";
        user = "root";
        extraOptions = {
          LogLevel = "QUIET";
          StrictHostKeyChecking = "no";
        };
      };
      "deskpi" = {
        user = "pi";
        hostname = "deskpi.local";
      };
      "ats*" = {
        user = "pi";
      };
      "ats1" = {
        hostname = "10.71.7.75";
      };
      "ats2" = {
        hostname = "10.71.7.72";
      };
      "ats4" = {
        hostname = "10.71.5.97";
      };
      "mikyla" = {
        user = "mikyla";
        hostname = "10.71.0.125";
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
    gcc
    git
    keepassxc
    lolcat
    nerd-fonts.jetbrains-mono
    ripgrep
    tmux
  ];
}
