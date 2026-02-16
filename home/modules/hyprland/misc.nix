{
  osConfig,
  lib,
  ...
}: let
  cfg = osConfig.my.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        input {
                kb_layout = us
                follow_mouse = 1
                sensitivity = 0
                # force_no_accel = 1

                touchpad {
                        natural_scroll = no
                        tap-and-drag = false
                }
        }

        gesture = 3, horizontal, workspace

        # Per device settings
        device {
                name = logitech-usb-receiver
                sensitivity = -0.7
        }
        device {
                name = logitech-pro-x-wireless
                sensitivity = -0.7
        }
        device {
                name = logitech-pro-x-wireless-1
                sensitivity = -0.7
        }
        device {
                name = logitech-pro-x-wireless-2
                sensitivity = -0.7
        }
        device {
                name = bcm5974
                sensitivity = 0
        }

        #               _
        #    ____ ___  (_)_________
        #   / __ `__ \/ / ___/ ___/
        #  / / / / / / (__  ) /__
        # /_/ /_/ /_/_/____/\___/

        # See https://wiki.hyprland.org/Configuring/Variables/
        misc {
                vrr = 0
                disable_hyprland_logo = true
                disable_splash_rendering = true
                force_default_wallpaper = 0
                initial_workspace_tracking = 1 # Would love if this worked at all -.-
        }

        xwayland {
                force_zero_scaling = true
        }

        cursor {
                # Disables hardware cursors. Set to 2 for auto which disables them on Nvidia, while keeping them enabled otherwise.
                no_hardware_cursors = 2
        }
      '';
    };
  };
}
