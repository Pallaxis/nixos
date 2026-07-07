{
  config,
  lib,
  ...
}: let
  cfg = config.my.localsend;
in {
  options.my.localsend = {
    enable = lib.mkEnableOption "Localsend";
  };
  config = lib.mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
