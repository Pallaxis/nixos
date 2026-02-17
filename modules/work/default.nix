{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.my.modules.work;
in {
  options.my.modules.work.enable =
    lib.mkEnableOption "Packages used for work";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # ansible
      # ansible-core
      # audacity
      # dpkg
      # krita
      # openbsd-netcat
      chromium
      ddcutil
      ffmpeg-full
      slack
      tio
    ];
  };
}
