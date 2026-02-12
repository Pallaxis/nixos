{pkgs, ...}: {
  # Kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  ### SYSTEM PROGRAMS ###
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    dunst
    fd
    file
    fzf
    git
    glib
    grimblast
    jq
    nodejs
    pavucontrol
    rofi
    thunderbird
    udisks
    wl-clipboard
  ];
}
