{
  flake.modules.homeManager.shell = {config, ...}: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    programs.bash = {
      enable = true;
      enableCompletion = true;
    };
  };
}
