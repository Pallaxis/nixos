{
  flake.modules.nixos.locale = {
    services.xserver.xkb.layout = "us";
    console.useXkbConfig = true;
    time.timeZone = "Pacific/Auckland";
    i18n.defaultLocale = "en_NZ.UTF-8";
  };
}
