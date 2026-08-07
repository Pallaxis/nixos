{inputs, ...}: {
  flake.modules.nixos.thinkpad = {
    imports = with inputs.self.modules.nixos; [
      system-desktop
      systemd-boot

      hyprland
      work-packages
    ];
    networking.hostName = "thinkpad";

    # Oclea rule
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
    '';

    # Stops accidental power button presses
    services.logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandlePowerKeyLongPress = "powereoff";
    };

    # PrtSc button used as meta key
    services.keyd = {
      keyboards.caps-swap.settings = {
        main = {
          sysrq = "layer(meta)";
        };
      };
    };
  };
}
