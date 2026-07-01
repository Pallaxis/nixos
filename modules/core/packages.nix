{pkgs, ...}: {
  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  ### SYSTEM PROGRAMS ###
  programs = {
    firefox.enable = true;
    zsh = {
      enable = true;
      enableCompletion = false;
    };
    neovim.enable = true;
  };

  qt.enable = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
    fd
    file
    fzf
    git
    glib
    grimblast
    imv
    jq
    ldns
    libsForQt5.qt5ct
    man-pages
    nodejs
    pavucontrol
    quickshell
    udisks
    usbutils
    wl-clipboard
  ];
}
