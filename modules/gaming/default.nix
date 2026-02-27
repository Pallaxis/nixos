{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.gaming;
in {
  options.my.modules.gaming.enable =
    lib.mkEnableOption "Enables gaming module";

  config = lib.mkIf cfg.enable {
    my.modules.flatpak.enable = false;
    ### Steam
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    programs.gamescope = {
      enable = true;
      capSysNice = true;
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
      wineWow64Packages.full
      winetricks
    ];
  };
}
