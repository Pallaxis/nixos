{pkgs, ...}: {
  # might change this dir to 'core'
  # Home modules every system needs
  my.home.modules = {
    ssh.enable = true;
    thunderbird.enable = true;
    catppuccin.enable = true;
    syncthing.enable = true;
  };
  programs = {
    obs-studio.enable = true;
    man.generateCaches = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "Pallaxis";
          email = "sam_e3u@hotmail.com";
        };
        diff = {
          tool = "nvimdiff";
        };
        difftool = {
          nvimdiff = {
            cmd = "nvim -c 'DiffviewOpen $LOCAL..$REMOTE'";
          };
        };
      };
    };
  };

  ### UNSORTED USER PACKAGES ###
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
