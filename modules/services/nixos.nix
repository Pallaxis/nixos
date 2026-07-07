{lib, ...}: {
  options.my.services.handleMonitorConnect.enable =
    lib.mkEnableOption "Handle monitor connect service";
}
