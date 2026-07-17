{pkgs, ...}: let
  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil pkgs.dunst];
    text = ''
      has_brightnessctl=false
      has_ddcutil=false

      cache_path=/tmp/brightness-script-temp-value
      dim_level=20
      step_delay=0.01

      brightnessctl g >/dev/null 2>&1 && has_brightnessctl=true
      ddcutil getvcp 0x10 >/dev/null 2>&1 && has_ddcutil=true

      if ! $has_brightnessctl && ! $has_ddcutil; then
        echo "No supported brightness backend found."
        exit 1
      fi

      parse_brightnessctl_to_percentage() {
        local max current

        max=$(brightnessctl m)
        current=$(brightnessctl g)

        echo $(( current * 100 / max ))
      }

      get_brightness() {
        if $has_brightnessctl; then
            parse_brightnessctl_to_percentage
        elif $has_ddcutil; then
            ddcutil getvcp 0x10 | grep -oP 'current value =\s*\K\d+'
        fi
      }

      brightnessctl_transition() {
        local start=$1
        local end=$2
        local step=$(( start < end ? 1 : -1 ))
        local i=$start

        while (( i != end )); do
          brightnessctl set "''${i}%"
          sleep "$step_delay"
          (( i += step ))
        done

        brightnessctl set "''${end}%"
      }

      transition_brightness() {
        local from=$1
        local to=$2

        if $has_brightnessctl; then
          brightnessctl_transition "$from" "$to" &
        fi

        if $has_ddcutil; then
          ddcutil setvcp 0x10 "$to"
        fi

        wait
      }

      change_brightness() {
        local amount=$1

        if $has_brightnessctl; then
          if (( amount >= 0 )); then
            brightnessctl set "''${amount}%+"
          else
            brightnessctl set "''${amount#-}%-"
          fi
        fi

        if $has_ddcutil; then
          if (( amount >= 0 )); then
            ddcutil setvcp 0x10 + "$amount"
          else
            ddcutil setvcp 0x10 - "$((-amount))"
          fi
        fi
      }

      dim_monitors() {
        local current

        current=$(get_brightness) || return

        printf '%s\n' "$current" > "$cache_path"

        transition_brightness "$current" "$dim_level"
      }

      restore_brightness() {
        local current cached

        current=$(get_brightness) || return

        if [[ ! -f $cache_path ]]; then
          echo "No cached brightness found. Restoring to 100%."
          transition_brightness "$current" 100
          return 2
        fi

        read -r cached < "$cache_path"

        transition_brightness "$current" "$cached"

        rm -f "$cache_path"
      }

      increase_brightness() {
        change_brightness 5
      }

      decrease_brightness() {
        change_brightness -5
      }

      if [[ -n $1 ]] && declare -f "$1" >/dev/null; then
        "$1"
      else
        echo "Function '$1' does not exist or no function name provided."
        exit 1
      fi
    '';
  };
in {
  home.packages = [brightness];
}
