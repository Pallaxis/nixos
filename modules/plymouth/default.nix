{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.modules.plymouth;
in {
  options.my.modules.plymouth.enable =
    lib.mkEnableOption "Plymouth";

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
      };
      # Enables silent boot
      consoleLogLevel = 3;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];

      loader.timeout = 0;
    };
  };
}
