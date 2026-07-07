{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.gaming;
in {
  options.my.gaming.enable =
    lib.mkEnableOption "Enables gaming module";

  config = lib.mkIf cfg.enable {
    my.lutris.enable = true;
    my.flatpak.enable = false;
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamescope = {
        enable = true;
        # FIXME: https://github.com/nixos/nixpkgs/issues/523200
        capSysNice = false;
      };
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
      wineWow64Packages.stagingFull
      winetricks
    ];
  };
}
