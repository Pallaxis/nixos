{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    apps.work.enable =
      lib.mkEnableOption "Packages used for work";
  };
  config = lib.mkIf config.apps.work.enable {
    environment.systemPackages = with pkgs; [
      ansible
      ansible-core
      audacity
      chromium
      ddcutil
      dpkg
      krita
      openbsd-netcat
      tio
    ];
  };
}
