{pkgs, ...}: let
  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil pkgs.dunst];
    text = ''
      parse_brightnessctl_to_percentage() {
        max_value=$(brightnessctl m)
        current_value=$(brightnessctl g)
        echo $(( current_value * 100 / max_value ))
      }

      cache_path=/tmp/brightness-script-temp-value

      dim_monitors() {
        if brightnessctl g >/dev/null 2>&1; then
          parsed_value=$(parse_brightnessctl_to_percentage)
        else
          parsed_value=$(ddcutil getvcp 0x10 | grep -oP 'current value =\s*\K\d+')
        fi

        echo "$parsed_value" > "$cache_path"

        if brightnessctl g >/dev/null 2>&1; then
          brightnessctl set 20%
        fi

        if ddcutil getvcp 0x10 >/dev/null 2>&1; then
          ddcutil setvcp 0x10 20
        fi
      }

      restore_brightness(){
        read -r cached_brightness < "$cache_path"

        if brightnessctl g >/dev/null 2>&1; then
          brightnessctl set "$cached_brightness"%
        fi

        if ddcutil getvcp 0x10 >/dev/null 2>&1; then
          ddcutil setvcp 0x10 "$cached_brightness"
        fi
      }

      increase_brightness(){
        if brightnessctl g >/dev/null 2>&1; then
          brightnessctl set 5%+
        fi

        if ddcutil getvcp 0x10 >/dev/null 2>&1; then
          ddcutil setvcp 0x10 + 5
        fi
      }

      decrease_brightness(){
        if brightnessctl g >/dev/null 2>&1; then
          brightnessctl set 5%-
        fi

        if ddcutil getvcp 0x10 >/dev/null 2>&1; then
          ddcutil setvcp 0x10 - 5
        fi
      }

      if [ -n "$1" ] && declare -f "$1" > /dev/null; then
          "$1"
      else
          echo "Function '$1' does not exist or no function name provided."
      fi
    '';
  };
in {
  home.packages = [brightness];
}
