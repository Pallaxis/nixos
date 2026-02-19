{
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./hyprland
    ./lutris
    ./nvim
    ./scripts
    ./services
    ./ssh
    ./terminal
  ];
  config = {
    my.home.modules =
      {
        ssh.enable = true;
      }
      // lib.optionalAttrs osConfig.my.modules.gaming.enable {
        lutris.enable = true;
      }
      // lib.optionalAttrs (osConfig.my.host.name == "thinkpad") {
      };
    catppuccin = {
      enable = true;
      accent = "blue";
      flavor = "mocha";

      hyprlock.useDefaultConfig = false;
      zsh-syntax-highlighting.enable = false;
      thunderbird.profile = "henry";
    };
    programs.thunderbird = {
      enable = true;
      profiles = {
        henry = {
          isDefault = true;
          settings = {
            "mailnews.start_page.enabled" = false;
          };
        };
      };
    };
  };
}
