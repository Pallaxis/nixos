{
  osConfig,
  config,
  lib,
  ...
}: let
  cfg = osConfig.my.modules.hyprland;
in {
  options.my.home.modules = {
    hyprland = {
      workspaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-1"
          "3, monitor:DP-1"
          "4, monitor:DP-1"
          "5, monitor:DP-1"
          "6, monitor:DP-2, default:true"
          "7, monitor:DP-2"
          "8, monitor:DP-2"
          "9, monitor:DP-2"
          "10, monitor:DP-2"
        ];
        description = "Workspaces for Hyprland";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        windowrule = [
          "match:class ^(app.drey.Warp)$, float on # Warp-Gtk"
          "match:class ^(blueman-manager)$, float on"
          "match:class ^(com.github.rafostar.Clapper)$, float on # Clapper-Gtk"
          "match:class ^(com.github.unrud.VideoDownloader)$, float on # VideoDownloader-Gkk"
          "match:class ^(eog)$, float on # Imageviewer-Gtk"
          "match:class ^(firefox)$ match:title:^(Library)$, float on"
          "match:class ^(io.github.alainm23.planify)$, float on # planify-Gtk"
          "match:class ^(io.gitlab.theevilskeleton.Upscaler)$, float on # Upscaler-Gtk"
          "match:class ^(kvantummanager)$, float on"
          "match:class ^(net.davidotek.pupgui2)$, float on # ProtonUp-Qt"
          "match:class ^(nm-applet)$, float on"
          "match:class ^(nm-connection-editor)$, float on"
          "match:class ^(nwg-look)$, float on"
          "match:class ^(org.gnome.Calculator)$, float on"
          "match:class ^(org.kde.ark)$, float on"
          "match:class ^(org.kde.dolphin)$ match:title:^(Copying — Dolphin)$, float on"
          "match:class ^(org.kde.dolphin)$ match:title:^(Progress Dialog — Dolphin)$, float on"
          "match:class ^(org.kde.polkit-kde-authentication-agent-1)$, float on"
          "match:class ^(org.pulseaudio.pavucontrol)$, float on"
          "match:class ^(qt5ct)$, float on"
          "match:class ^(qt6ct)$, float on"
          "match:class ^(Signal)$, float on # Signal-Gtk"
          "match:class ^(steam) match:title:negative:^(Steam.*), float on"
          "match:class ^(org.mozilla.Thunderbird)$ match:title:negative:^(Mozilla Thunderbird)$, float on"
          "match:class ^(xdg-desktop-portal-gtk)$, float on"
          "match:class ^(vlc)$, float on"
          "match:class ^(yad)$, float on # Protontricks-Gtk"
          "match:title ^(Picture-in-Picture)$, float on"
          "match:title ^(Keybindings)$, float on"
        ];
        layerrule = [
          "match:namespace rofi, blur on"
          "match:namespace logout_dialog, blur on"
          "match:namespace notifications, blur on"
          "match:namespace swaync-control-center, blur on"
          "match:namespace swaync-notification-window, blur on"
          "match:namespace waybar, blur on"
          "match:namespace notifications, ignore_alpha 1"
          "match:namespace rofi, ignore_alpha 1"
          "match:namespace swaync-control-center, ignore_alpha 1"
          "match:namespace swaync-notification-window, ignore_alpha 1"
        ];
        workspace = config.my.home.modules.hyprland.workspaces;
      };
      extraConfig = ''
        windowrule {
            name = osrs fix
            match:class = net-runelite-client-RuneLite,title:^(win\d+)$, float # Fixes tooltip hover bug
            no_focus = 1
        }
        windowrule {
            name = keepassxc
            match:class = ^(org.keepassxc.KeePassXC)$
            no_screen_share = 1 # Prevents leaking password manager over screenshare
        }
        dwindle {
            pseudotile = yes
            preserve_split = yes
        }

        master {
            new_status = master
        }

        general {
            gaps_in = 2
            gaps_out = 5
            border_size = 2
            col.active_border = rgba(f5c2e7ff) rgba(cba6f7ff) 45deg
            col.inactive_border = rgba(89b4faff) rgba(89b4fadf) 45deg
            layout = dwindle
            resize_on_border = true
        }

        group {
            col.border_active = rgba(eb6f92ff) rgba(c4a7e7ff) 45deg
            col.border_inactive = rgba(31748fcc) rgba(9ccfd8cc) 45deg
            col.border_locked_active = rgba(eb6f92ff) rgba(c4a7e7ff) 45deg
            col.border_locked_inactive = rgba(31748fcc) rgba(9ccfd8cc) 45deg
        }

        decoration {
            dim_special = 0.3
            rounding = 10
            shadow {
                enabled = no
            }
            blur {
                special = true
                enabled = yes
                size = 6
                passes = 3
                new_optimizations = on
                ignore_opacity = on
                xray = false
            }
        }
      '';
    };
  };
}
