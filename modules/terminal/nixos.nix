{lib, ...}: {
  options.my.terminal.enable =
    lib.mkEnableOption "Terminal";
  config = {
    my = {
      zellij.enable = false;
      tmux.enable = true;
      zsh.enable = true;
    };
  };
}
