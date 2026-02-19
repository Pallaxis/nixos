{pkgs, ...}: {
  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  ### SYSTEM PROGRAMS ###
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    neovim.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dunst
    fd
    file
    fzf
    git
    glib
    grimblast
    jq
    ldns
    man-pages
    nodejs
    pavucontrol
    rofi
    udisks
    wl-clipboard
  ];
}
