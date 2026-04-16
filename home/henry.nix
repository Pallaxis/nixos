{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./modules
  ];

  # My user's modules enabled here
  my.home.modules =
    {
      ssh.enable = true;
      thunderbird.enable = true;
      catppuccin.enable = true;
      syncthing.enable = true;
    }
    // lib.optionalAttrs osConfig.my.modules.gaming.enable {
      lutris.enable = true;
    }
    // lib.optionalAttrs (osConfig.my.host.name == "thinkpad") {
    };

  # Basic user info
  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "26.05";
  };

  ### LAZY DOTFILES ###
  home.file.".config/rofi".source = ./dotfiles/rofi;

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;

  ### USER PACKAGES ###
  home.packages = with pkgs; [
    cowsay
    fastfetch
    fortune
    gcc
    keepassxc
    lolcat
    nerd-fonts.jetbrains-mono
  ];
}
