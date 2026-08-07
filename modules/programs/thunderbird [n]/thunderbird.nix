{
  flake.modules.homeManager.thunderbird = {
    programs.thunderbird = {
      enable = true;
      profiles = {
        username = {
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
