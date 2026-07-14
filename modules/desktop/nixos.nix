{
  lib,
  config,
  username,
  ...
}: let
  cfg = config.my.desktop;
in {
  options.my.desktop.enable =
    lib.mkEnableOption "Desktop";
  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;
    users.users.${username} = {
      extraGroups = ["i2c"];
    };
  };
}
