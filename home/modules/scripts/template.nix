{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.script.NAME; # change NAME, use camelCase for internal and kebab-case for name =
  myScript = pkgs.writeShellApplication {
    name = "NAME";
    runtimeInputs = [pkgs.socat pkgs.coreutils]; # change these to be whatever the script depends on

    text = ''
      # script goes here
    '';
  };
in {
  options.my.scripts.NAME.enable =
    lib.mkEnableOption "DESC"; # quick description of what this module does

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [myScript];
  };
}
