{
  pkgs,
  lib,
  ...
}: let
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    sha256 = "TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };
in {
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
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autocd = true;
    completionInit = ''
      _dumpfile="$ZDOTDIR/.zcompdump"
      _zwcfile="$ZDOTDIR/.zcompdump.zwc"

      if [[ -f "$_zwcfile" && "$_zwcfile" -nt /run/current-system/sw/share/zsh/site-functions ]]; then
        autoload -Uz compinit && compinit -C
      else
        autoload -Uz compinit && compinit
        zcompile "$_dumpfile"
      fi
    '';
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
    };
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
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "sudo";
        src = pkgs.runCommand "sudo-plugin-src" {} ''
          mkdir -p $out
          cp ${pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh";
            sha256 = "sha256-pXylDddgevJlHbVYFRz7L+oBOb8hQbGWi4e7Z9lcLFk=";
          }} $out/sudo.plugin.zsh
        '';
      }
    ];
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
        # # Make general or attach to it if it's already running
        # if [[ -z "$TMUX" && -n "$DISPLAY" ]]; then
        #     if [[ -z $(tmux list-sessions) ]]; then
        #   exec tmux new-session -s general
        #     elif [[ -z $(tmux list-clients) ]]; then
        #   exec tmux new-session -A -s general
        #     fi
        # fi
        if [[ -z "$ZELLIJ" ]]; then
          # if general has clients attached make random
          if [[ $(zellij -s general action list-clients | wc -l) -gt 1 ]]; then
            zellij
          else
            zellij attach -c general
          fi

          # exit
        fi
      '';
      zshPrompt = lib.mkOrder 1000 "PROMPT=$'\n''%F{#89b4fa}%~%f %(?..%F{red}%?%f )'$'\n''%F{#cba6f7}%f '";
      fzfTab = lib.mkOrder 1200 ''
        bindkey "^[[3~" delete-char
        export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        # System FZF settings
        export FZF_CTRL_T_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
        export FZF_DEFAULT_OPTS="--preview-window=up:70% --bind=ctrl-d:page-down,ctrl-u:page-up --color=query:#89b4fa,hl:#f7b3e2,hl:#cba6f7,hl+:#cba6f7,selected-hl:#89b4fa,fg:#89b4fa,fg+:#89b4fa,bg+:#313244,info:#cba6f7,border:#cba6f7,pointer:#cba6f7,marker:#cba6f7"
        # Uses bat as manpager (replaces bat-extras package)
        export MANPAGER="bat -plman"
        export WORDCHARS="*?_.[]~&;!#$%^(){}<>"

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
        # xdg-open wrapper
        open() {
          (
          xdg-open "$1" &> /dev/null
          local exit_code=$?

          case $exit_code in
            0)
              # Success - usually no output needed
              ;;
            1)
              echo "Error: Error in command line syntax" >&2
              ;;
            2)
              echo "Error: A file passed doesn't exist" >&2
              ;;
            3)
              echo "Error: A required tool could not be found" >&2
              ;;
            4)
              echo "Error: The action failed" >&2
              ;;
            *)
              echo "Error: xdg-open failed with exit code $exit_code" >&2
              ;;
          esac
          ) & disown
        }
        ns() {
          # Create an array to store the prefixed packages
          local pkgs=()
          for pkg in "$@"; do
            pkgs+=("nixpkgs#$pkg")
          done

          # Run the nix shell command with all prefixed packages
          nix shell "''${pkgs[@]}" --command zsh -c "export IN_NIX_SHELL=impure; exec zsh"
        }
      '';
    in
      lib.mkMerge [zshConfigEarlyInit zshPrompt fzfTab functions];
    shellAliases = let
      pretty = ''--pretty="%C(#89b4fa)%h%Creset -%C(auto)%d%Creset %s %C(#a6e3a1)(%ad) %C(bold #cba6f7)<%an>%Creset"'';
    in {
      # eza
      ls = "eza --icons=auto --sort=type --no-quotes --oneline"; # Short list
      ll = "eza --icons=auto --sort=type --no-quotes --all --long --header --smart-group"; # long list
      lls = "eza --icons=auto --sort=size --no-quotes --all --long --header --total-size --smart-group"; # long list with dir sizes shown
      lm = "eza --icons=auto --sort=modified --no-quotes --all --long --header --smart-group --modified"; # sorts by modifed date
      lc = "eza --icons=auto --sort=created --no-quotes --all --long --header --smart-group --created"; # sorts by created date
      tree = "eza --tree --icons=auto --sort=type"; # Same as tree but with colours

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

      # Git
      gst = "git status";
      gl = "git log --oneline --decorate --graph --all ${pretty}";
      ga = "git add";
      gd = "git diff";
      gc = "git commit --verbose";
      gca = "git commit --verbose --all";
      "gca!" = "git commit --verbose --all --amend";
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$status$all$character";
      directory = {
        style = "blue";
        truncation_length = 5;
        truncation_symbol = "../";
      };
      git_branch = {
        style = "mauve";
      };
      cmd_duration = {
        style = "peach";
      };
      character = {
        success_symbol = "[❯](mauve)";
        error_symbol = "[❯](red)";
      };
      status = {
        style = "red";
        disabled = false;
        symbol = "";
        not_executable_symbol = "";
        not_found_symbol = "";
        sigint_symbol = "";
        signal_symbol = "";
      };
    };
  };
  programs.zellij = {
    enable = true;
    layouts = {
      default = {
        layout = {
          _children = [
            {
              pane = {};
            }
            {
              pane = {
                size = 1;
                borderless = true;
                plugin = {
                  location = "zellij:tab-bar";
                };
              };
            }
            # {
            #   pane = {
            #     size = 1;
            #     borderless = true;
            #     plugin = {
            #       location = "file:${zjstatus}";
            #       format_left = "{mode} #[fg=#89B4FA,bold]{session}";
            #       format_center = "{tabs}";
            #       format_right = "{command_git_branch} {datetime}";
            #       format_space = "";
            #
            #       border_enabled = "false";
            #       border_char = "─";
            #       border_format = "#[fg=#6C7086]{char}";
            #       border_position = "top";
            #
            #       hide_frame_for_single_pane = "true";
            #
            #       mode_normal = "#[bg=blue] ";
            #       mode_tmux = "#[bg=#ffc387] ";
            #
            #       tab_normal = "#[fg=#6C7086] {name} ";
            #       tab_active = "#[fg=#9399B2,bold,italic] {name} ";
            #
            #       command_git_branch_command = "git rev-parse --abbrev-ref HEAD";
            #       command_git_branch_format = "#[fg=blue] {stdout} ";
            #       command_git_branch_interval = "10";
            #       command_git_branch_rendermode = "static";
            #
            #       datetime = "#[fg=#6C7086,bold] {format} ";
            #       datetime_format = "%A, %d %b %Y %H:%M";
            #       datetime_timezone = "Europe/Berlin";
            #     };
            #   };
            # }
          ];
        };
      };
    };
    settings = {
      show_startup_tips = false;
      mouse_hover_effects = false;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 4000;
      post_command_discovery_hook = ''
        WRAPPER_START="zsh -c"

        if [[ "$RESURRECT_COMMAND" == "$WRAPPER_START"* ]]; then
            echo "$RESURRECT_COMMAND"
        else
          echo "zsh -c '$RESURRECT_COMMAND; exec zsh -i'"
        fi
      '';

      keybinds = {
        _props.clear-defaults = true;

        shared_except = {
          _args = ["tmux" "locked"];
          _children = [
            {
              bind = {
                _args = ["Ctrl s"];
                SwitchToMode = "Tmux";
              };
            }
            {
              bind = {
                _args = ["Ctrl h"];
                MoveFocus = "Left";
              };
            }
            {
              bind = {
                _args = ["Ctrl j"];
                MoveFocus = "Down";
              };
            }
            {
              bind = {
                _args = ["Ctrl k"];
                MoveFocus = "Up";
              };
            }
            {
              bind = {
                _args = ["Ctrl l"];
                MoveFocus = "Right";
              };
            }
            {
              bind = {
                _args = ["Alt 1"];
                GoToTab = 1;
              };
            }
            {
              bind = {
                _args = ["Alt 2"];
                GoToTab = 2;
              };
            }
            {
              bind = {
                _args = ["Alt 3"];
                GoToTab = 3;
              };
            }
            {
              bind = {
                _args = ["Alt 4"];
                GoToTab = 4;
              };
            }
            {
              bind = {
                _args = ["Alt 5"];
                GoToTab = 5;
              };
            }
            {
              bind = {
                _args = ["Alt 6"];
                GoToTab = 6;
              };
            }
            {
              bind = {
                _args = ["Alt 7"];
                GoToTab = 7;
              };
            }
            {
              bind = {
                _args = ["Alt 8"];
                GoToTab = 8;
              };
            }
            {
              bind = {
                _args = ["Alt 9"];
                GoToTab = 9;
              };
            }
            {
              bind = {
                _args = ["Alt 0"];
                GoToTab = 10;
              };
            }
          ];
        };
        tmux = {
          _children = [
            {
              bind = {
                _args = ["["];
                EditScrollback = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["s"];
                LaunchOrFocusPlugin = {
                  _args = ["zellij:session-manager"];
                  floating = true;
                };
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["Ctrl s"];
                Write = 2;
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["\""];
                NewPane = "Down";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["%"];
                NewPane = "Right";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["z"];
                ToggleFocusFullscreen = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["c"];
                NewTab = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = [","];
                SwitchToMode = "RenameTab";
                TabNameInput = 0;
              };
            }
            {
              bind = {
                _args = ["p"];
                GoToPreviousTab = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["n"];
                GoToNextTab = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["h"];
                MoveFocus = "Left";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["l"];
                MoveFocus = "Right";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["j"];
                MoveFocus = "Down";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["k"];
                MoveFocus = "Up";
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["o"];
                FocusNextPane = {};
              };
            }
            {
              bind = {
                _args = ["d"];
                Detach = {};
              };
            }
            {
              bind = {
                _args = ["Space"];
                NextSwapLayout = {};
              };
            }
            {
              bind = {
                _args = ["x"];
                CloseFocus = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["Esc"];
                SwitchToMode = "Normal";
              };
            }
          ];
        };
        scroll = {
          _children = [
            {
              bind = {
                _args = ["Esc"];
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["PageUp"];
                PageScrollUp = {};
              };
            }
            {
              bind = {
                _args = ["PageDown"];
                PageScrollDown = {};
              };
            }
            {
              bind = {
                _args = ["Home"];
                ScrollToTop = {};
              };
            }
            {
              bind = {
                _args = ["End"];
                ScrollToBottom = {};
              };
            }
            {
              bind = {
                _args = ["/"];
                SwitchToMode = "entersearch";
              };
            }
            {
              bind = {
                _args = ["?"];
                SwitchToMode = "entersearch";
              };
            }
            {
              bind = {
                _args = ["Ctrl u"];
                PageScrollUp = {};
              };
            }
            {
              bind = {
                _args = ["Ctrl d"];
                PageScrollDown = {};
              };
            }
            {
              bind = {
                _args = ["j"];
                ScrollDown = {};
              };
            }
            {
              bind = {
                _args = ["k"];
                ScrollUp = {};
              };
            }
            {
              bind = {
                _args = ["e"];
                EditScrollback = {};
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["D"];
                DumpScreen = {
                  _args = ["/tmp/zellij-dump.txt"];
                  full = true;
                };
              };
            }
          ];
        };
        entersearch = {
          _children = [
            {
              bind = {
                _args = ["Esc"];
                SwitchToMode = "normal";
              };
            }
            {
              bind = {
                _args = ["Enter"];
                SwitchToMode = "search";
              };
            }
          ];
        };
        search = {
          _children = [
            {
              bind = {
                _args = ["Esc"];
                SwitchToMode = "scroll";
              };
            }
            {
              bind = {
                _args = ["n"];
                Search = {
                  _args = ["down"];
                };
              };
            }
            {
              bind = {
                _args = ["p"];
                Search = {
                  _args = ["up"];
                };
              };
            }
            {
              bind = {
                _args = ["PageUp"];
                PageScrollUp = {};
              };
            }
            {
              bind = {
                _args = ["PageDown"];
                PageScrollDown = {};
              };
            }
            {
              bind = {
                _args = ["Ctrl u"];
                PageScrollUp = {};
              };
            }
            {
              bind = {
                _args = ["Ctrl d"];
                PageScrollDown = {};
              };
            }
            {
              bind = {
                _args = ["Home"];
                ScrollToTop = {};
              };
            }
            {
              bind = {
                _args = ["End"];
                ScrollToBottom = {};
              };
            }
          ];
        };

        renametab = {
          _children = [
            {
              bind = {
                _args = ["Enter"];
                SwitchToMode = "Normal";
              };
            }
            {
              bind = {
                _args = ["Esc" "Ctrl c"];
                UndoRenameTab = {};
                SwitchToMode = "Normal";
              };
            }
          ];
        };
      };
    };
  };
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
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
}
