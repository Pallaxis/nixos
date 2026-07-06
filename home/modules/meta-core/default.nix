{pkgs, ...}: {
  # Home modules every system needs
  my.home.modules = {
    ssh.enable = true;
    syncthing.enable = true;
  };
  programs = {
    man.generateCaches = true;
  };

  home.packages = with pkgs; [
    gcc
  ];
}
