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

  environment.systemPackages = with pkgs; [
    fd
    file
    fzf
    git
    glib
    grimblast
    imv
    jq
    ldns
    man-pages
    nodejs
    pavucontrol
    rofi
    udisks
    usbutils
    wl-clipboard
  ];
}
