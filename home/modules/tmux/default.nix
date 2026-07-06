{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.tmux;
in {
  options.my.home.modules.tmux.enable =
    lib.mkEnableOption "Tmux";

  config = lib.mkIf cfg.enable {
    xdg.configFile."tmux/tmux.conf".source = ./tmux.conf;
    programs.tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
      ];
    };
    programs.zsh.initContent = lib.mkOrder 500 ''
      # # Make general or attach to it if it's already running
      if [[ -z "$TMUX" && -n "$DISPLAY" ]]; then
        if [[ -z $(tmux list-sessions) ]]; then
          exec tmux new-session -s general
        elif [[ -z $(tmux list-clients) ]]; then
          exec tmux new-session -A -s general
        fi
      fi
    '';
  };
}
