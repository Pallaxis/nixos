{...}: let
  # cfg = config.my.host;
in {
  imports = [
    ./hyprland
    ./nvim
    ./env.nix
    ./shell.nix
  ];
  config = {
    #   my.home.modules =
    #     {
    #       networking.enable = true;
    #     }
    #     // lib.optionalAttrs (cfg.role == "desktop") {
    #       # fonts.enable = true;
    #       # my-user.enable = true;
    #       # sound.enable = true;
    #       hyprland.enable = true;
    #       # system-recovery.enable = true;
    #     }
    #     // lib.optionalAttrs (cfg.role == "server") {
    #     };
  };
}
