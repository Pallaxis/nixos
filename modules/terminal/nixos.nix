{
  config,
  lib,
  ...
}: let
  cfg = config.my.terminal;
in {
  options.my.terminal.enable =
    lib.mkEnableOption "Terminal";
  config = lib.mkIf cfg.enable {
    my = {
      tmux.enable = true;
      zellij.enable = false;
      zsh.enable = true;
    };
  };
}
