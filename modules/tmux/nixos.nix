{lib, ...}: {
  options.my.tmux.enable =
    lib.mkEnableOption "Tmux";
}
