{...}: {
  imports = [
    ./modules
  ];

  # Basic user info
  home = {
    username = "henry";
    homeDirectory = "/home/henry";
    stateVersion = "26.05";
  };
  programs = {
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

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;
}
