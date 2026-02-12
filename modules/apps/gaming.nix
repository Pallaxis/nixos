{
  config,
  lib,
  pkgs,
  ...
}: {
  options.apps.gaming = {
    enable = lib.mkEnableOption "Enables gaming module";
  };
  config = lib.mkIf config.apps.gaming.enable {
    my.modules.flatpak.enable = false;
    ### Steam
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # May be needed to get gamescope to run
    # programs.steam.package = pkgs.steam.override {
    #   extraPkgs = pkgs': with pkgs'; [
    #     xorg.libXcursor
    #     xorg.libXi
    #     xorg.libXinerama
    #     xorg.libXScrnSaver
    #     libpng
    #     libpulseaudio
    #     libvorbis
    #     stdenv.cc.cc.lib # Provides libstdc++.so.6
    #     libkrb5
    #     keyutils
    #     # Add other libraries as needed
    #   ];
    # };

    environment.systemPackages = with pkgs; [
      gamma-launcher
      protonup-ng
      wineWowPackages.stagingFull
      winetricks
    ];
  };
}
