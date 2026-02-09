{
  pkgs,
  lib,
  ...
}: {
  programs.foot.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autocd = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
    };
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.2.0";
          sha256 = "q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "command-not-found"
      ];
    };
    history = {
      size = 10000;
      save = 10000;
      append = true;
      ignoreSpace = true;
      ignoreAllDups = true;
    };
    setOptions = [
      "inc_append_history"
      "no_flow_control"
      "extended_glob"
      "prompt_subst"
    ];
    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        # Make general or attach to it if it's already running
        if [[ -n "$DISPLAY" ]]; then
            if [[ -z $(tmux list-sessions) ]]; then
          tmux new-session -s general
            elif [[ -z $(tmux list-clients) ]]; then
          tmux new-session -A -s general
            fi
        fi
      '';
      zshPrompt = lib.mkOrder 1000 "PROMPT=$'\n''%F{#89b4fa}%~%f %(?..%F{red}%?%f )'$'\n''%F{#cba6f7}%f '";
      fzfTab = lib.mkOrder 1200 ''
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        # System FZF settings
        export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_DEFAULT_OPTS="--preview-window=up:70% --bind=ctrl-d:page-down,ctrl-u:page-up --color=query:#89b4fa,hl:#f7b3e2,hl:#cba6f7,hl+:#cba6f7,selected-hl:#89b4fa,fg:#89b4fa,fg+:#89b4fa,bg+:#313244,info:#cba6f7,border:#cba6f7,pointer:#cba6f7,marker:#cba6f7"
        # Uses bat as manpager (replaces bat-extras package)
        export MANPAGER="bat -plman"

        #
        # Completion
        #
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        # Disable prompt and use menu selection
        zstyle ':completion:*' list-prompt ""
        zstyle ':completion:*' menu select=long
        # fzf-tab settings
        zstyle ':fzf-tab:*' fzf-preview '[[ -d $realpath ]] && eza -1 --icons=auto $realpath || bat --paging=never --style=plain --color=always $realpath' # Shows ls or bat based on context
        zstyle ':fzf-tab:*' default-color "" # Color when there is no group
        zstyle ':fzf-tab:*' fzf-flags --color="query:#89b4fa,hl:#f7b3e2,hl:#cba6f7,hl+:#cba6f7,selected-hl:#89b4fa,fg:#89b4fa,fg+:#89b4fa,bg+:#313244,info:#cba6f7,border:#cba6f7,pointer:#cba6f7,marker:#cba6f7" # Catppuccin colors
        zstyle ':fzf-tab:*' fzf-bindings 'ctrl-d:page-down' 'ctrl-u:page-up'
        zstyle ':fzf-tab:*' fzf-min-height 20 # Opens in tmux popup window
        # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup # Opens in tmux popup window
        # zstyle ':fzf-tab:*' popup-smart-tab no # Opens in tmux popup window
        # zstyle ':fzf-tab:*' popup-min-size 200 40 # Sizes for tmux window
        zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word' # Systemctl status
        zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ''${P word}' # Environment variables
      '';
      functions = lib.mkAfter ''
        #
        # Functions
        #
        ssh-host() {
            # Pulls the IP from .ssh config for supplied arg
            if [[ $# -ne 1 ]]; then
        	echo "Supply only one arg to pull from ssh config"
        	return 1
            fi
            ssh -G $1 | awk '/^hostname/{print $2}'
        }
        stopwatch() {
            start=$(date +%s)
            while true; do
        	time="$(($(date +%s) - $start))"
        	printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
            done
        }
        countdown() {
            start="$(( $(date '+%s') + $1))"
            while [ $start -ge $(date +%s) ]; do
        	time="$(( $start - $(date +%s) ))"
        	printf '%s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        	sleep 0.1
            done
            notify-send Countdown Completed!
        }
        udm() {
            udisksctl mount -b "$1" > /dev/null 2>&1
            drive_mountpoint=$(udisksctl info -b "$1" | awk '/MountPoints:/ {print $2}')
            cd "$drive_mountpoint" || echo "cd failed"
        }
        udu() {
            drive_mountpoint=$(udisksctl info -b "$1" | awk '/MountPoints:/ {print $2}')
            if [[ -n "$drive_mountpoint" && "$PWD" == "$drive_mountpoint" ]]; then
        	cd '..'
            fi
            udisksctl unmount -b "$1"
        }
        # Checks a dir exists & is not in path, then prepends to PATH
        add_paths() {
          for directory in "$@"; do
            [[ -d "$directory" && ! "$PATH" =~ (^|:)$directory(:|$) ]] && PATH="$directory:$PATH"
          done
        }
        add_paths ~/.local/bin ~/.local/share/system-setup/bin

      '';
    in
      lib.mkMerge [zshConfigEarlyInit zshPrompt fzfTab functions];
    shellAliases = {
      # eza
      ls = "eza --icons=auto --sort=type --no-quotes --oneline"; # Short list
      ll = "eza --icons=auto --sort=type --no-quotes --all --long --header --smart-group"; # long list
      lls = "eza --icons=auto --sort=size --no-quotes --all --long --header --total-size --smart-group"; # long list with dir sizes shown
      lm = "eza --icons=auto --sort=modified --no-quotes --all --long --header --smart-group --modified"; # sorts by modifed date
      lc = "eza --icons=auto --sort=created --no-quotes --all --long --header --smart-group --created"; # sorts by created date
      tree = "eza --tree --icons=auto"; # Same as tree but with colours

      # Handy dir change shortcuts
      "-" = "cd -";
      ".." = "cd ..";
      "..." = "cd ../..";
      "..3" = "cd ../../..";
      "..4" = "cd ../../../..";
      "..5" = "cd ../../../../..";
      c = "clear"; # Clear terminal
      mkdir = "mkdir -p"; # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
      cp = "cp -r"; # Same for cp
      scp = "scp -r";

      # Other

      sudo = "sudo ";
      vi = "nvim";
      ffplay = "ffplay -fflags nobuffer -flags low_delay -probesize 32 -analyzeduration 1";
      cat = "bat --paging=never --style=grid,header-filename"; # Cat but with colors
      diff = "diff --color"; # Enables color for diffs
      info = "info --vi-keys";
      fd-aged = "fd -0 -t d | xargs -0 stat --format '%Y %n' | sort -n";
      resolve = "avahi-resolve-host-name";
    };
  };
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
      # Fixes nvim long esc wait time
      set -sg escape-time 10

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
