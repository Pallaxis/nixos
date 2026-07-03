{self, ...}: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
      consoleMode = "max";
    };
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Locale
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;
  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";
}
