{pkgs, ...}: {
  imports = [
    ./zellij.nix
    ./tmux.nix
    ./zsh.nix
  ];
  config = {
    my.home.modules = {
      zellij.enable = true;
      tmux.enable = false;
      zsh.enable = true;
    };

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetbrainsMono Nerd Font Mono:size=11";
          pad = "5x5 center";
          term = "foot";
        };
      };
    };
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.ripgrep = {
      enable = true;
      arguments = ["--smart-case"];
    };
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };
    programs.yazi.enable = true;
    programs.eza.enable = true;
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
        update_ms = "1000";
      };
    };
    programs.bat = {
      enable = true;
      config = {
        map-syntax = "*.conf:INI";
      };
    };
  };
}
