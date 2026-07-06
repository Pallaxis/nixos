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

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;
}
