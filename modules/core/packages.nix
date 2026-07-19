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
    age
    brightnessctl
    fd
    file
    fzf
    gdu
    git
    glib
    grimblast
    imagemagick
    imv
    jq
    ldns
    libsForQt5.qt5ct
    man-pages
    mpv
    nodejs
    pavucontrol
    python3
    quickshell
    sops
    udisks
    unrar
    unzip
    usbutils
    wl-clipboard
    zip
  ];
}
