{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.zsh;
in {
  options.my.home.modules.zsh.enable =
    lib.mkEnableOption "Zsh";

  config = lib.mkIf cfg.enable {
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
          export MANPAGER="bat -plman --strip-ansi always"
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
          gdt() {
            nvim -c "DiffviewOpen $1..$2"
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
  };
}
