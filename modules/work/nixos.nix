{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.work;
in {
  options.my.work.enable =
    lib.mkEnableOption "Packages used for work";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # ansible
      # ansible-core
      # audacity
      # dpkg
      # krita
      # openbsd-netcat
      libreoffice-fresh
      chromium
      gimp
      ddcutil
      ffmpeg-full
      slack
      (tio.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "tio";
          repo = "tio";
          rev = "6fb3a64ba234cc255f9637ba938cf0c01e132e4a";
          sha256 = "mM8/2ozsXXKAhfTdf4+4f/ZBmhguS4D76zCfvF1VQC0=";
        };
      }))
    ];
  };
}
