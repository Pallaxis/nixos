{...}: {
  imports = [
    ../../modules
    ./disk-config.nix
  ];

  my = {
    host = {
      role = "desktop";
    };
  };

  apps.work.enable = true;
  apps.others.enable = true;

  # Only need this on thinkpad
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="4255", MODE="0666"
  '';

  # Unique to thinkpad, PrtSc button where meta key should be
  services.keyd = {
    keyboards.caps-swap.settings = {
      main = {
        sysrq = "layer(meta)";
      };
    };
  };

  system.stateVersion = "25.11"; # Don't ever change this
}
