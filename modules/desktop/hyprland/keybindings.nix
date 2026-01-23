{ ... }:
  {
  home-manager.users.henry = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "SUPER, H, movefocus, l"
          "SUPER, J, movefocus, d"
          "SUPER, K, movefocus, u"
          "SUPER, L, movefocus, r"
        ];
        bindd = [
          # Window/Session actions
          "SUPER, C, Kills active window, exec, hyprctl dispatch killactive"
          "SUPER, W, Toggles window floating, togglefloating"
          "SUPER, G, Toggle focused window to group, togglegroup"
          "ALT, return, Toggle fullscreen, fullscreen"
          # Application shortcuts
          "SUPER SHIFT, minus, Start hyprlock, exec, hyprlock"
          "SUPER SHIFT, F, Pin focused window, exec, ~/.config/hypr/scripts/windowpin"
          "CONTROL, ESCAPE, Toggle waybar, exec, killall waybar || waybar"
          "SUPER ALT, W, Wallpaper selection script, exec, ~/.config/hypr/scripts/select-wp"
          "SUPER, T, Launch terminal, exec, foot"
          "SUPER, F, Launch browser, exec, firefox"
          "SUPER, ESCAPE, Launch btop, exec, setsid -f $term -e btop"
          "SUPER SHIFT, slash, Show keybinds, exec, setsid -f $term -T Keybindings -e $scr_path/keybindings"
          # Rofi
          "SUPER, SPACE, Launch desktop programs, exec, pkill -x rofi || rofi -show drun"
          "SUPER, tab, Switch between desktop programs, exec, pkill -x rofi || rofi -show window"
          "SUPER, R, Browse system files, exec, pkill -x rofi || rofi -show run"
          "SUPER, backspace, Logout menu, exec, ~/.config/rofi/scripts/logout-menu"
          # Audio control
          ", XF86AudioMute, Toggle audio mute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioLowerVolume, Lower volume, exec, ~/.config/hypr/scripts/change-volume 5%-"
          ", XF86AudioRaiseVolume, Raise volume, exec, ~/.config/hypr/scripts/change-volume 5%+"

          "SUPER, P, Copy selection to clipboard, exec, ~/.config/hypr/scripts/screenshot-tool freeze-area"
          "SUPER SHIFT, P, Saves screenshot selection to named file, exec, ~/.config/hypr/scripts/screenshot-tool freeze-area-save"
          "SUPER ALT, P, Copy focused monitor to clipboard, exec, ~/.config/hypr/scripts/screenshot-tool copy-focused-monitor"
          "SUPER CONTROL, P, Copy all monitors to clipboard, exec, ~/.config/hypr/scripts/screenshot-tool copy-all-monitors"

          "SUPER, 1, Switch to workspace 1, exec, ~/.config/hypr/scripts/toggle-workspace-number 1"
          "SUPER, 2, Switch to workspace 2, exec, ~/.config/hypr/scripts/toggle-workspace-number 2"
          "SUPER, 3, Switch to workspace 3, exec, ~/.config/hypr/scripts/toggle-workspace-number 3"
          "SUPER, 4, Switch to workspace 4, exec, ~/.config/hypr/scripts/toggle-workspace-number 4"
          "SUPER, 5, Switch to workspace 5, exec, ~/.config/hypr/scripts/toggle-workspace-number 5"
          "SUPER, 6, Switch to workspace 6, exec, ~/.config/hypr/scripts/toggle-workspace-number 6"
          "SUPER, 7, Switch to workspace 7, exec, ~/.config/hypr/scripts/toggle-workspace-number 7"
          "SUPER, 8, Switch to workspace 8, exec, ~/.config/hypr/scripts/toggle-workspace-number 8"
          "SUPER, 9, Switch to workspace 9, exec, ~/.config/hypr/scripts/toggle-workspace-number 9"
          "SUPER, 0, Switch to workspace 10, exec, ~/.config/hypr/scripts/toggle-workspace-number 10"
          "SUPER SHIFT, 1, Move focused window to workspace 1, movetoworkspace, 1"
          "SUPER SHIFT, 2, Move focused window to workspace 2, movetoworkspace, 2"
          "SUPER SHIFT, 3, Move focused window to workspace 3, movetoworkspace, 3"
          "SUPER SHIFT, 4, Move focused window to workspace 4, movetoworkspace, 4"
          "SUPER SHIFT, 5, Move focused window to workspace 5, movetoworkspace, 5"
          "SUPER SHIFT, 6, Move focused window to workspace 6, movetoworkspace, 6"
          "SUPER SHIFT, 7, Move focused window to workspace 7, movetoworkspace, 7"
          "SUPER SHIFT, 8, Move focused window to workspace 8, movetoworkspace, 8"
          "SUPER SHIFT, 9, Move focused window to workspace 9, movetoworkspace, 9"
          "SUPER SHIFT, 0, Move focused window to workspace 10, movetoworkspace, 10"
          "SUPER ALT, 1, Move focused window to workspace 1 silently, movetoworkspacesilent, 1"
          "SUPER ALT, 2, Move focused window to workspace 2 silently, movetoworkspacesilent, 2"
          "SUPER ALT, 3, Move focused window to workspace 3 silently, movetoworkspacesilent, 3"
          "SUPER ALT, 4, Move focused window to workspace 4 silently, movetoworkspacesilent, 4"
          "SUPER ALT, 5, Move focused window to workspace 5 silently, movetoworkspacesilent, 5"
          "SUPER ALT, 6, Move focused window to workspace 6 silently, movetoworkspacesilent, 6"
          "SUPER ALT, 7, Move focused window to workspace 7 silently, movetoworkspacesilent, 7"
          "SUPER ALT, 8, Move focused window to workspace 8 silently, movetoworkspacesilent, 8"
          "SUPER ALT, 9, Move focused window to workspace 9 silently, movetoworkspacesilent, 9"
          "SUPER ALT, 0, Move focused window to workspace 10 silently, movetoworkspacesilent, 10"
          "SUPER CTRL, L, Go to next workspace, workspace, r+1 "
          "SUPER CTRL, H, Go to prev workspace, workspace, r-1"
          "SUPER CTRL ALT, L, Move window to next workspace, movetoworkspace, r+1"
          "SUPER CTRL ALT, H, Move window to prev workspace, movetoworkspace, r-1"
          "SUPER SHIFT CONTROL, H, Move window left, movewindow, l"
          "SUPER SHIFT CONTROL, J, Move window down, movewindow, d"
          "SUPER SHIFT CONTROL, K, Move window up, movewindow, u"
          "SUPER SHIFT CONTROL, L, Move window right, movewindow, r"
          "SUPER, mouse_down, Scroll to next workspace, workspace, e+1"
          "SUPER, mouse_up, Scroll to prev workspace, workspace, e-1"
          "SUPER ALT, S, Move focused window to special workspace silently, movetoworkspacesilent, special"
          "SUPER SHIFT, S, Move focused window to special workspace, movetoworkspace, special"
          "SUPER, S, Toggle special workspace, togglespecialworkspace,"
          "SUPER, D, Toggle layout, togglesplit,"
        ];
        bindl = [
          # More audio control
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
        binde = [
          "SUPER SHIFT, H, resizeactive, -30 0"
          "SUPER SHIFT, J, resizeactive, 0 30"
          "SUPER SHIFT, K, resizeactive, 0 -30"
          "SUPER SHIFT, L, resizeactive, 30 0"
        ];
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
          "SUPER, Z, movewindow"
          "SUPER, X, resizewindow"
        ];
        bindeld = [
          ", XF86MonBrightnessUp, Increase brightness, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, Decrease brightness, exec, brightnessctl set 5%-"
        ];
      };
    };
  };
}
