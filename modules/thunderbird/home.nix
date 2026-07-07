{
  osConfig,
  lib,
  ...
}: let
  cfg = osConfig.my.thunderbird;
in {
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
