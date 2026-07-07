{pkgs, ...}: {
  # Settings to do across all systems
  programs = {
    man.generateCaches = true;
  };

  home.packages = with pkgs; [
    gcc
  ];
}
