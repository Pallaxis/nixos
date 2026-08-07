{
  flake.modules.homeManager.hyprland = {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock --grace 0"; # Avoid starting multiple hyprlock instances.
          before_sleep_cmd = "pidof hyprlock || hyprlock --grace 0 --no-fade-in"; # Lock before suspend.
          # Disabling after_sleep_cmd as it is causing the screen to turn off after wake, screen is on after wake anyway so its redundant
          # after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = 'enable' })'"; # To avoid having to press a key twice to turn on the display.
          inhibit_sleep = "2"; # Waits for lock before sleeping
        };

        listener = [
          # After 5 mins
          # Locks session
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }

          # After 10 mins
          # Dims monitors
          # Brightens monitors after activity
          {
            timeout = 600;
            on-timeout = "brightness dim_monitors";
            on-resume = "brightness restore_brightness";
          }

          # After 10 mins
          # Turns off keyboard backlight
          # Turns on keyboard backlight after activity
          {
            timeout = 600;
            on-timeout = "brightnessctl -sd '*':kbd_backlight set 0";
            on-resume = "brightnessctl -rd '*':kbd_backlight";
          }

          # After 30 mins
          # Turns off all monitors
          # Turns on all monitors after activity
          {
            timeout = 1800;
            on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = 'disable' } )'";
            on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = 'enable' })'";
          }

          # After 120 mins
          # Suspends system
          {
            timeout = 7200;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
