{ config, pkgs, ... }:

{
  home.username = "henry";
  home.homeDirectory = "/home/henry";
  home.stateVersion = "25.11";

  ### LAZY DOTFILES ###
  home.file.".config/nvim".source = ./dotfiles/nvim;
  home.file.".config/waybar".source = ./dotfiles/waybar;
  home.file.".config/bat".source = ./dotfiles/bat;
  home.file.".config/foot".source = ./dotfiles/foot;
  home.file.".config/rofi".source = ./dotfiles/rofi;
  home.file.".zshrc".source = ./dotfiles/.zshrc;
  # home.file.".local/share/wallpapers".source = ./wallpapers;

  # links fonts to where programs expect them to be
  fonts.fontconfig.enable = true;

  
  ### USER SERVICES ###
  services.ssh-agent = {
    enable = true;
    socket = "ssh-agent.socket";
    enableZshIntegration = true;
  };
  services.hypridle.enable = true;
  # ensure hyprpaper starts automatically
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      # preload = [ "${config.home.homeDirectory}/.local/share/wallpapers/kcd2-hawk-two-horses.png" ];
      # wallpaper = [ ",${config.home.homeDirectory}/.local/share/wallpapers/kcd2-hawk-two-horses.png" ];
      preload = [ "${../../wallpapers/kcd2-hawk-two-horses.png}" ];
      wallpaper = [
        {
          monitor = "";
          path = "${../../wallpapers/kcd2-hawk-two-horses.png}";
        }
      ];
    };
  };
  services.hyprpolkitagent.enable = true;
  # wayland.windowManager.hyprland.systemd.variables = ["--all"];

  home.packages = with pkgs; [
    bat
    btop
    cowsay
    eza
    fastfetch
    foot
    fortune
    fzf
    gcc
    git
    keepassxc
    lolcat
    nerd-fonts.jetbrains-mono
    tldr
    tmux
  ];


  ### USER PROGRAMS ###
  # programs.zsh.enable = true;
  programs.foot.enable = true;
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_status_style "rounded"
          set -ogq @catppuccin_window_text " #W"
          set -ogq @catppuccin_window_current_text " #W"
          set -g status-left ""
          set -g status-right "#{?window_zoomed_flag,#[fg=#{@thm_mauve}]ZOOMED ,}#{E:@catppuccin_status_session}"
        '';
      }
    ];
    extraConfig = ''
      # General settings
      set -g prefix C-s
      set -g mouse on
      set -g base-index 1
      set -g pane-base-index 1 
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-option -g status-position bottom
      set-option -g history-limit 10000
      set-option -g detach-on-destroy off

      # <C-b> r to reload config quickly
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # Set vi-mode
      set-window-option -g mode-keys vi

      bind C-t popup -E "~/.config/tmux/scripts/popup.sh"
      # Rofi to create or switch to session
      bind C-n run-shell "~/.config/tmux/scripts/new-session.sh"

      # Vim keybindings
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      # Binds for arrow key layer
      bind Left select-pane -L
      bind Down select-pane -D
      bind Up select-pane -U
      bind Right select-pane -R

      # 1 indexed session list
      bind s choose-tree -ZsK '#{?#{e|<:#{line},9},#{e|+:1,#{line}},#{?#{e|<:#{line},35},M-#{a:#{e|+:97,#{e|-:#{line},9}}},}}'

      # Tmux select text binds
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      #bind -T copy-mode-vi y send -X copy-pipe "wl-copy" \; display-message "Copied"
      bind -T copy-mode-vi Enter send -X copy-selection
      bind -T copy-mode-vi y send -X copy-selection \; display-message "Copied"

      # Ctrl+Alt vim keys to switch windows
      bind -n C-M-k previous-window
      bind -n C-M-j next-window

      # Bind Alt+1 through Alt+9 to switch to respective windows
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Opens new panes in the current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Creates new windows based on current path
      unbind c
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
