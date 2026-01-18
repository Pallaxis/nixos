{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Locale
  services.xserver.xkb.layout = "us";
  console.useXkbConfig = true;
  time.timeZone = "Pacific/Auckland";
}
