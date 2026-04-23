{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.modules.thunderbird;
in {
  options.my.home.modules.thunderbird.enable =
    lib.mkEnableOption "Thunderbird";

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {
        henry = {
          isDefault = true;
          settings = {
            "mailnews.start_page.enabled" = false;
            "calendar.week.start" = 1;
          };
        };
      };
    };
  };
}
