let
  username = "henry";
in {
  flake.modules.homeManager."${username}" = {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Pallaxis";
            email = "sam_e3u@hotmail.com";
          };
          diff = {
            tool = "nvimdiff";
          };
          difftool = {
            nvimdiff = {
              cmd = "nvim -c 'DiffviewOpen $LOCAL..$REMOTE'";
            };
          };
        };
      };
    };
  };
}
