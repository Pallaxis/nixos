{...}: {
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
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Locale
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;
  time.timeZone = "Pacific/Auckland";
}
