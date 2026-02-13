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
        theme = "circle_hud";
        themePackages = [
          (pkgs.adi1090x-plymouth-themes.override {
            selected_themes = ["circle_hud"];
          })
        ];
        # Custom theme, borked atm
        # theme = "circle_hud";
        # themePackages = [
        #   (pkgs.stdenv.mkDerivation {
        #     name = "circle_hud";
        #     src = ./circle_hud;
        #
        #     installPhase = ''
        #       mkdir -p $out/share/plymouth/themes/circle_hud
        #       cp -r * $out/share/plymouth/themes/circle_hud/
        #     '';
        #   })
        # ];
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

      loader.timeout = 3; # shows generations at boot for this long
    };
  };
}
