{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.modules.waybar;

  mkScript = name: deps:
    pkgs.writeShellScriptBin name ''
      export PATH=${pkgs.lib.makeBinPath deps}:$PATH
      ${builtins.readFile ./scripts/${name}.sh}
    '';
  ramUsage = mkScript "ram-usage" [pkgs.gnused pkgs.gawk pkgs.procps];
  cpuUsage = mkScript "cpu-usage" [pkgs.gnused pkgs.gawk pkgs.procps pkgs.lm_sensors];
  notifications = mkScript "notifications" [pkgs.gnused pkgs.dunst pkgs.jq];
  kernelModuleCheck = mkScript "kernel-module-check" [];
in {
  options.my.home.modules.waybar.enable =
    lib.mkEnableOption "Waybar";

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      settings = {
        main = {
          "style" = {
            "font" = "JetbrainsMono Nerd Font Mono";
          };
          "layer" = "top";
          "modules-left" = ["hyprland/workspaces"];
          "modules-center" = ["clock#date" "idle_inhibitor" "clock#time"];
          "modules-right" = ["custom/kernel-check" "systemd-failed-units" "tray" "network" "custom/ram-usage" "custom/cpu-usage" "pulseaudio" "battery" "custom/notifications" "privacy"];

          "hyprland/workspaces" = {
            "format" = "{icon}";
            "persistent-only" = true;
            "format-icons" = {
              "1" = " web";
              "2" = " term";
              "5" = " slack";
              "9" = " pass";
              "10" = " email";
              "default" = " any";
            };
            "persistent-workspaces" = {
              "*" = [1 2 3 4 5];
              "eDP-1" = [6 7 8 9 10];
            };
          };
          "idle_inhibitor" = {
            "format" = "";
            "tooltip" = true;
            "tooltip-format-activated" = "Idle Inhibited";
            "tooltip-format-deactivated" = "Able to idle";
            "start-activated" = false;
          };
          "clock#time" = {
            "format" = "󱑂 {:%H:%M}";
            "tooltip" = false;
            "min-length" = 8;
            "max-length" = 8;
          };
          "clock#date" = {
            "format" = "󰨳 {:%d-%m}";
            "tooltip-format" = "<tt>{calendar}</tt>";
            "calendar" = {
              "mode" = "month";
              "mode-mon-col" = 3;
              "weeks-pos" = "right";
              "on-scroll" = 1;
              "format" = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            "actions" = {
              "on-click" = "shift_reset";
              "on-click-right" = "mode";
              "on-scroll-up" = "shift_up";
              "on-scroll-down" = "shift_down";
            };
          };
          "custom/kernel-check" = {
            "exec" = "${kernelModuleCheck}/bin/kernel-module-check";
            "return-type" = "json";
            "interval" = 300;
            "format" = "{}";
          };
          "systemd-failed-units" = {
            "hide-on-ok" = true;
            "format" = "{nr_failed_system} failed system, {nr_failed_user} failed user!";
          };
          "network" = {
            "format" = " {bandwidthUpBits}  {bandwidthDownBits}";
            # "format-ethernet" = " ";
            # "format-wifi" = " ";
            # "format-disconnected" = "󱘖 ";
            # "format-disabled" = " ";
            "tooltip-format" = "{ifname}\n{ipaddr}/{cidr}\n{netmask}\n{gwaddr}";
            "tooltip-format-disconnected" = "Network Disconnected";
            "tooltip-format-disabled" = "Network Disabled";
          };
          "custom/ram-usage" = {
            "exec" = "${ramUsage}/bin/ram-usage";
            "return-type" = "json";
            "tooltip" = true;
            "interval" = 5;
            "min-length" = 6;
            "max-length" = 6;
          };
          "custom/cpu-usage" = {
            "exec" = "${cpuUsage}/bin/cpu-usage";
            "return-type" = "json";
            "tooltip" = true;
            "interval" = 5;
            "min-length" = 6;
            "max-length" = 6;
          };
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "format-muted" = "󰝟 {volume}%";
            "format-icons" = {
              "default" = ["󰕿" "󰖀" "󰕾"];
              "headphone" = "󰋋";
              "headset" = "󰋋";
            };
            "tooltip" = true;
            "tooltip-format" = "Device: {desc}";
            "on-click" = "pavucontrol";
            "on-click-middle" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "on-scroll-up" = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "on-scroll-down" = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
            "min-length" = 6;
            "max-length" = 6;
          };
          "battery" = {
            "states" = {
              "full" = 100;
              "warning" = 30;
              "critical" = 15;
            };
            "full-at" = 96;
            "format" = "{icon} {capacity}%";
            "format-icons" = ["󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂"];
            "format-full" = "󰁹 {capacity}%";
            "format-warning" = "󰁻 {capacity}%";
            "format-critical" = "󱃍 {capacity}%";
            "format-charging" = "󰂄 {capacity}%";
            "tooltip-format" = "Discharging: {time}";
            "tooltip-format-charging" = "Charging: {time}";
            "interval" = 5;
            "min-length" = 6;
            "max-length" = 6;
          };
          "custom/notifications" = {
            "exec" = "${notifications}/bin/notifications";
            "return-type" = "json";
            "format" = "{}";
            "tooltip" = true;
            "interval" = 5;
            "on-click" = "dunstctl history-clear";
          };
          "privacy" = {
            "ignore" = [
              {
                "type" = "screenshare";
                "name" = "obs";
              }
            ];
          };
        };
      };
      style = ''
        * {
          font-family: "JetbrainsMono Nerd Font", monospace;
          font-size: 12px;
          color: white;
          /* text-shadow: 0 0 1.5px rgba(0, 0, 0, 10); */
        }

        /* Sets bar transparent */
        window#waybar {
          background: transparent;
          color: white;
        }

        .modules-left {
          padding: 0px 2px;
          margin:0px 0px 0px 10px;
        }
        .modules-center {
          padding: 0px 2px;
          margin:0px 0px 0px 0px;
        }
        .modules-right {
          padding: 0px 2px;
          margin:0px 10px 0px 0px;
        }

        #workspaces button {
          padding: 0px 5px;
          background: transparent;
          color: white;
          border-top: 2px solid transparent;
          border-radius: 0px;
        }
        #workspaces button.visible {
          border-top: 2px solid @mauve;
        }
        #workspaces button.active {
          background: alpha(@mauve, 0.5);
        }

        #idle_inhibitor {
          font-size: 15pt;
          min-width: 24px;  /* keeps the icon from collapsing */
          padding-left: 14px;
          padding-right: 18px;
          margin-left: 0px;
          margin-right: 0px;
        }
        #custom-notifications, #idle_inhibitor.activated, #systemd-failed-units.degraded {
          color: @red;
        }

        #custom-update, #network, #custom-ram-usage, #custom-cpu-usage, #battery, #tray, #custom-notifications, #privacy{
          padding: 0px 3px;
        }
      '';
    };
  };
}
