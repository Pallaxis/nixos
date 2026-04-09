{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.zellij;
  vimZellijNavigator = pkgs.fetchurl {
    url = "https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm";
    sha256 = "d+Wi9i98GmmMryV0ST1ddVh+D9h3z7o0xIyvcxwkxY0=";
  };
in {
  options.my.home.modules.zellij.enable =
    lib.mkEnableOption "Zellij";

  config = lib.mkIf cfg.enable {
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
        # post_command_discovery_hook = ''
        #   WRAPPER_START="zsh -c"
        #
        #   if [[ "$RESURRECT_COMMAND" == "$WRAPPER_START"* ]]; then
        #       echo "$RESURRECT_COMMAND"
        #   else
        #     SAFE_CMD=$(printf "%q" "$RESURRECT_COMMAND; exec zsh -i")
        #     echo "zsh -c $SAFE_CMD"
        #   fi
        # '';
        load_plugins = {
          _children = [
            {
              path = "file:${vimZellijNavigator}";
            }
          ];
        };

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
              {
                bind = {
                  _args = ["Ctrl h"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "move_focus";
                    payload = "left";
                  };
                };
              }
              {
                bind = {
                  _args = ["Ctrl j"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "move_focus";
                    payload = "down";
                  };
                };
              }
              {
                bind = {
                  _args = ["Ctrl k"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "move_focus";
                    payload = "up";
                  };
                };
              }
              {
                bind = {
                  _args = ["Ctrl l"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "move_focus";
                    payload = "right";
                  };
                };
              }
              {
                bind = {
                  _args = ["Alt h"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "resize";
                    payload = "left";
                  };
                };
              }
              {
                bind = {
                  _args = ["Alt j"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "resize";
                    payload = "down";
                  };
                };
              }
              {
                bind = {
                  _args = ["Alt k"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "resize";
                    payload = "up";
                  };
                };
              }
              {
                bind = {
                  _args = ["Alt l"];
                  MessagePlugin = {
                    _args = ["file:${vimZellijNavigator}"];
                    name = "resize";
                    payload = "right";
                  };
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
  };
}
