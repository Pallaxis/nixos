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
      // lib.optionalAttrs osConfig.apps.gaming.enable {
        lutris.enable = true;
      }
      // lib.optionalAttrs (osConfig.my.host.name == "thinkpad") {
      };
  };
}
