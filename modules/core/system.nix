{...}: {
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Locale
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";
}
