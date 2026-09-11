{
  flake.modules.nixos.cli-tools = {pkgs, ...}: {
    # Lower level stuff I'd need in any system with a cli
    environment.systemPackages = with pkgs; [
      age
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
      nethogs
      nmap
      nodejs
      parallel
      pavucontrol
      python3
      quickshell
      tcpdump
      unrar
      unzip
      usbutils
      wl-clipboard
      zip
    ];
  };

  flake.modules.homeManager.cli-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      cowsay
      fastfetch
      fortune
      keepassxc
      lolcat
      nerd-fonts.jetbrains-mono
    ];
  };
}
